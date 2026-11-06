import nodemailer from 'nodemailer';

interface SendVerificationOptions {
  email: string;
  displayName: string;
  code: string;
  token: string;
}

export async function sendVerificationEmail({
  email,
  displayName,
  code,
  token,
}: SendVerificationOptions): Promise<void> {
  const host = process.env.SMTP_HOST;
  const port = parseInt(process.env.SMTP_PORT || '587', 10);
  const user = process.env.SMTP_USER;
  const pass = process.env.SMTP_PASS;
  const service = process.env.SMTP_SERVICE; // e.g. 'gmail'
  const from = process.env.SMTP_FROM || `"Yegna Health" <${user || 'no-reply@yegnahealth.org'}>`;

  const backendUrl = process.env.BACKEND_PUBLIC_URL || 'http://localhost:5000';
  const verifyUrl = `${backendUrl}/api/auth/verify-email?token=${token}`;

  // 1. If SMTP or Gmail is configured, attempt real email delivery
  if ((host || service) && user && pass) {
    try {
      const transporter = service
        ? nodemailer.createTransport({
            service,
            auth: { user, pass },
          })
        : nodemailer.createTransport({
            host,
            port,
            secure: port === 465,
            auth: { user, pass },
          });

      await transporter.sendMail({
        from,
        to: email,
        subject: 'Verify your Yegna Health account',
        html: `
          <div style="font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; max-width: 580px; margin: 0 auto; padding: 32px 24px; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 16px;">
            <div style="text-align: center; margin-bottom: 24px;">
              <h1 style="color: #0284c7; font-size: 26px; font-weight: 800; margin: 0;">Yegna Health</h1>
              <p style="color: #64748b; font-size: 14px; margin-top: 4px;">Youth Health & Learning Platform</p>
            </div>
            <h2 style="color: #0f172a; font-size: 20px; font-weight: 700;">Confirm your email address</h2>
            <p style="color: #334155; font-size: 15px; line-height: 1.6;">Hello <strong>${displayName}</strong>,</p>
            <p style="color: #334155; font-size: 15px; line-height: 1.6;">Thank you for registering. Please click the button below to verify your email and activate your account:</p>
            <div style="text-align: center; margin: 28px 0;">
              <a href="${verifyUrl}" style="background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%); color: #ffffff; padding: 14px 32px; border-radius: 12px; text-decoration: none; font-weight: 700; font-size: 16px; display: inline-block; box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);">
                Confirm Email & Go to Login
              </a>
            </div>
            <p style="color: #64748b; font-size: 14px; line-height: 1.5;">Alternatively, your 6-digit confirmation code is:</p>
            <div style="background-color: #f0fdf4; border: 1px solid #bbf7d0; padding: 14px; border-radius: 10px; text-align: center; margin: 16px 0;">
              <span style="font-size: 28px; font-weight: 800; letter-spacing: 6px; color: #166534;">${code}</span>
            </div>
            <hr style="border: none; border-top: 1px solid #f1f5f9; margin: 28px 0;" />
            <p style="font-size: 12px; color: #94a3b8; text-align: center; margin: 0;">If you did not create a Yegna Health account, you can safely ignore this email.</p>
          </div>
        `,
      });
      console.log(`[Mailer] Real email dispatched successfully to ${email}`);
      return;
    } catch (err) {
      console.error(`[Mailer] Error sending real email to ${email}:`, err);
    }
  }

  // 2. Development / Local Environment: Console simulation
  console.log(`
┌────────────────────────────────────────────────────────────────────────┐
│ 📧 YEGNA HEALTH - VERIFICATION EMAIL DISPATCHED                        │
├────────────────────────────────────────────────────────────────────────┤
│ To:          ${email.padEnd(58)}│
│ Student:     ${displayName.padEnd(58)}│
│ 6-Digit Code:${(' ' + code).padEnd(58)}│
│ Link:        ${verifyUrl.padEnd(58)}│
│ Note:        Configure SMTP in server/.env for direct inbox delivery.  │
└────────────────────────────────────────────────────────────────────────┘
`);
}
