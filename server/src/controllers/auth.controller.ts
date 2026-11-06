import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { z } from 'zod';
import { prisma, config } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';
import { sendVerificationEmail } from '../utils/mailer.js';

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(4),
});

const registerSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  displayName: z.string().min(2),
});

const updateProfileSchema = z.object({
  displayName: z.string().min(2),
});

const updatePasswordSchema = z.object({
  newPassword: z.string().min(6),
});

export async function login(req: Request, res: Response) {
  try {
    const { email, password } = loginSchema.parse(req.body);
    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase().trim() },
    });

    if (!user) {
      return res.status(401).json({
        error: 'INVALID_CREDENTIALS',
        message: 'Email or password is incorrect.',
      });
    }

    if (user.isSuspended) {
      return res.status(403).json({
        error: 'ACCOUNT_SUSPENDED',
        message: 'This account has been suspended by community safety.',
      });
    }

    const isValid = await bcrypt.compare(password, user.passwordHash);
    if (!isValid) {
      return res.status(401).json({
        error: 'INVALID_CREDENTIALS',
        message: 'Email or password is incorrect.',
      });
    }

    // Require email confirmation before allowing login
    if (!user.isEmailVerified) {
      return res.status(403).json({
        error: 'EMAIL_NOT_CONFIRMED',
        message: 'Please confirm your email address before signing in. Check your inbox for the confirmation link.',
      });
    }

    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
        role: user.role,
        displayName: user.displayName,
      },
      config.jwtSecret,
      { expiresIn: '30d' }
    );

    return res.json({
      token,
      user: {
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        role: user.role,
        isEmailVerified: user.isEmailVerified,
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_FAILED', details: err.errors });
    }
    return res.status(500).json({ error: err.message || 'Login failed' });
  }
}

export async function register(req: Request, res: Response) {
  try {
    const { email, password, displayName } = registerSchema.parse(req.body);
    const existing = await prisma.user.findUnique({
      where: { email: email.toLowerCase().trim() },
    });

    if (existing) {
      return res.status(409).json({
        error: 'EMAIL_EXISTS',
        message: 'An account with this email address already exists.',
      });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);

    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    const verificationToken = jwt.sign(
      { email: email.toLowerCase().trim(), type: 'EMAIL_VERIFICATION' },
      config.jwtSecret,
      { expiresIn: '7d' }
    );

    const user = await prisma.user.create({
      data: {
        email: email.toLowerCase().trim(),
        displayName: displayName.trim(),
        passwordHash,
        role: 'STUDENT',
        isEmailVerified: false,
        verificationCode,
        verificationToken,
      },
    });

    await sendVerificationEmail({
      email: user.email,
      displayName: user.displayName,
      code: verificationCode,
      token: verificationToken,
    });

    await prisma.auditLog.create({
      data: {
        action: 'USER_REGISTERED',
        adminEmail: user.email,
        details: `Student registered: ${user.email}. Verification email dispatched.`,
      },
    });

    return res.status(201).json({
      success: true,
      verificationPending: true,
      email: user.email,
      message: 'Account created! Please check your email to confirm your account.',
      user: {
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        role: user.role,
        isEmailVerified: false,
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_FAILED', details: err.errors });
    }
    return res.status(500).json({ error: err.message || 'Registration failed' });
  }
}

export async function verifyEmail(req: Request, res: Response) {
  try {
    const token = req.query.token as string | undefined;
    const { email, code } = req.body || {};

    if (token) {
      const user = await prisma.user.findFirst({
        where: { verificationToken: token },
      });

      if (!user) {
        return res.status(400).send(`
          <!DOCTYPE html>
          <html>
          <head><title>Invalid Verification Link - Yegna Health</title></head>
          <body style="font-family: sans-serif; display: flex; align-items: center; justify-content: center; height: 100vh; background-color: #f8fafc; margin: 0;">
            <div style="background: white; padding: 40px; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); text-align: center; max-width: 440px;">
              <h2 style="color: #ef4444; margin-top: 0;">Invalid or Expired Link</h2>
              <p style="color: #64748b;">This email verification link is no longer valid. Please request a new confirmation email.</p>
            </div>
          </body>
          </html>
        `);
      }

      await prisma.user.update({
        where: { id: user.id },
        data: {
          isEmailVerified: true,
          verificationCode: null,
          verificationToken: null,
        },
      });

      await prisma.auditLog.create({
        data: {
          action: 'EMAIL_VERIFIED',
          adminEmail: user.email,
          details: `User verified email via confirmation link: ${user.email}`,
        },
      });

      const appUrl = process.env.CLIENT_APP_URL || 'http://localhost:8080';
      return res.send(`
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Email Confirmed - Yegna Health</title>
          <meta http-equiv="refresh" content="3;url=${appUrl}">
          <style>
            body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; display: flex; align-items: center; justify-content: center; min-height: 100vh; background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%); margin: 0; padding: 16px; }
            .card { background: white; padding: 44px 32px; border-radius: 24px; box-shadow: 0 20px 25px -5px rgba(2, 132, 199, 0.1), 0 8px 10px -6px rgba(2, 132, 199, 0.05); text-align: center; max-width: 440px; width: 100%; border: 1px solid #bae6fd; }
            .badge { width: 68px; height: 68px; background: #ecfdf5; border: 2px solid #a7f3d0; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 34px; margin-bottom: 20px; }
            h2 { color: #0f172a; font-size: 24px; font-weight: 800; margin: 0 0 10px 0; }
            p { color: #475569; font-size: 15px; line-height: 1.6; margin: 0 0 28px 0; }
            .btn { display: inline-block; background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%); color: white; text-decoration: none; padding: 14px 32px; border-radius: 14px; font-weight: 700; font-size: 15px; box-shadow: 0 4px 12px rgba(2, 132, 199, 0.25); }
            .btn:hover { background: #0369a1; }
            .countdown { font-size: 12.5px; color: #94a3b8; margin-top: 18px; font-weight: 500; }
          </style>
        </head>
        <body>
          <div class="card">
            <div class="badge">✓</div>
            <h2>Email Confirmed!</h2>
            <p>Your Yegna Health account has been verified successfully. You can now log in to the application.</p>
            <a href="${appUrl}" class="btn">Proceed to Login</a>
            <div class="countdown">Taking you to the login page in 3 seconds...</div>
          </div>
        </body>
        </html>
      `);
    }

    if (email && code) {
      const user = await prisma.user.findUnique({
        where: { email: email.toLowerCase().trim() },
      });

      if (!user) {
        return res.status(404).json({ error: 'USER_NOT_FOUND', message: 'User not found.' });
      }

      if (user.verificationCode !== code.trim()) {
        return res.status(400).json({ error: 'INVALID_CODE', message: 'The verification code entered is incorrect.' });
      }

      const updated = await prisma.user.update({
        where: { id: user.id },
        data: {
          isEmailVerified: true,
          verificationCode: null,
          verificationToken: null,
        },
      });

      const authToken = jwt.sign(
        {
          id: updated.id,
          email: updated.email,
          role: updated.role,
          displayName: updated.displayName,
        },
        config.jwtSecret,
        { expiresIn: '30d' }
      );

      return res.json({
        success: true,
        message: 'Email verified successfully!',
        token: authToken,
        user: {
          id: updated.id,
          email: updated.email,
          displayName: updated.displayName,
          role: updated.role,
          isEmailVerified: true,
        },
      });
    }

    return res.status(400).json({ error: 'BAD_REQUEST', message: 'Missing token or verification code.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message || 'Verification failed.' });
  }
}

export async function resendVerification(req: Request, res: Response) {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ error: 'EMAIL_REQUIRED', message: 'Email address is required.' });
    }

    const user = await prisma.user.findUnique({
      where: { email: email.toLowerCase().trim() },
    });

    if (!user) {
      return res.status(404).json({ error: 'USER_NOT_FOUND', message: 'User not found.' });
    }

    if (user.isEmailVerified) {
      return res.status(400).json({ error: 'ALREADY_VERIFIED', message: 'This email is already verified.' });
    }

    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();
    const verificationToken = jwt.sign(
      { email: user.email, type: 'EMAIL_VERIFICATION' },
      config.jwtSecret,
      { expiresIn: '7d' }
    );

    await prisma.user.update({
      where: { id: user.id },
      data: {
        verificationCode,
        verificationToken,
      },
    });

    await sendVerificationEmail({
      email: user.email,
      displayName: user.displayName,
      code: verificationCode,
      token: verificationToken,
    });

    return res.json({ success: true, message: 'New verification email dispatched.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message || 'Failed to resend verification.' });
  }
}

export async function me(req: AuthRequest, res: Response) {
  if (!req.user) {
    return res.status(401).json({ error: 'UNAUTHORIZED' });
  }

  const user = await prisma.user.findUnique({
    where: { id: req.user.id },
    select: {
      id: true,
      email: true,
      displayName: true,
      role: true,
      isSuspended: true,
      createdAt: true,
    },
  });

  if (!user) {
    return res.status(404).json({ error: 'USER_NOT_FOUND' });
  }

  if (user.isSuspended) {
    return res.status(403).json({
      error: 'ACCOUNT_SUSPENDED',
      message: 'This account has been suspended by community safety.',
    });
  }

  return res.json({ user });
}

export async function updateProfile(req: AuthRequest, res: Response) {
  if (!req.user) {
    return res.status(401).json({ error: 'UNAUTHORIZED' });
  }

  try {
    const { displayName } = updateProfileSchema.parse(req.body);
    const updated = await prisma.user.update({
      where: { id: req.user.id },
      data: { displayName: displayName.trim() },
      select: {
        id: true,
        email: true,
        displayName: true,
        role: true,
        isSuspended: true,
      },
    });

    return res.json({ user: updated });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_FAILED', details: err.errors });
    }
    return res.status(500).json({ error: err.message || 'Failed to update profile' });
  }
}

export async function updatePassword(req: AuthRequest, res: Response) {
  if (!req.user) {
    return res.status(401).json({ error: 'UNAUTHORIZED' });
  }

  try {
    const { newPassword } = updatePasswordSchema.parse(req.body);
    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(newPassword, salt);

    await prisma.user.update({
      where: { id: req.user.id },
      data: { passwordHash },
    });

    return res.json({ success: true, message: 'Password updated successfully' });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'VALIDATION_FAILED', details: err.errors });
    }
    return res.status(500).json({ error: err.message || 'Failed to update password' });
  }
}
