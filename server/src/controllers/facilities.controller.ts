import { Request, Response } from 'express';
import { z } from 'zod';
import { prisma } from '../config/index.js';
import { AuthRequest } from '../middleware/auth.middleware.js';

const facilitySchema = z.object({
  nameEn: z.string().min(2),
  nameAm: z.string().min(2),
  subCity: z.string().min(2),
  woreda: z.string().optional(),
  addressEn: z.string().min(2),
  addressAm: z.string().min(2),
  phone: z.string().min(5),
  latitude: z.number(),
  longitude: z.number(),
  operatingHours: z.string().default('08:30 - 17:30'),
  isVerified: z.boolean().default(true),
  services: z.array(z.string()).default([]),
});

export async function getAllFacilities(req: Request, res: Response) {
  try {
    const { subCity } = req.query;
    const where = subCity ? { subCity: String(subCity) } : {};
    const facilities = await prisma.facility.findMany({
      where,
      orderBy: { createdAt: 'desc' },
    });

    const parsed = facilities.map((f) => ({
      ...f,
      services: JSON.parse(f.services || '[]'),
    }));

    return res.json({ facilities: parsed });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function getFacilityById(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const facility = await prisma.facility.findUnique({ where: { id } });
    if (!facility) {
      return res.status(404).json({ error: 'Facility not found' });
    }
    return res.json({
      facility: {
        ...facility,
        services: JSON.parse(facility.services || '[]'),
      },
    });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}

export async function createFacility(req: AuthRequest, res: Response) {
  try {
    const data = facilitySchema.parse(req.body);
    const facility = await prisma.facility.create({
      data: {
        ...data,
        services: JSON.stringify(data.services),
      },
    });

    // Record audit log
    await prisma.auditLog.create({
      data: {
        action: 'FACILITY_CREATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Created youth facility: ${facility.nameEn} in ${facility.subCity}`,
      },
    });

    return res.status(201).json({
      facility: {
        ...facility,
        services: data.services,
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function updateFacility(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const data = facilitySchema.partial().parse(req.body);

    const updateData: any = { ...data };
    if (data.services !== undefined) {
      updateData.services = JSON.stringify(data.services);
    }

    const facility = await prisma.facility.update({
      where: { id },
      data: updateData,
    });

    await prisma.auditLog.create({
      data: {
        action: 'FACILITY_UPDATED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Updated facility: ${facility.nameEn}`,
      },
    });

    return res.json({
      facility: {
        ...facility,
        services: JSON.parse(facility.services || '[]'),
      },
    });
  } catch (err: any) {
    if (err instanceof z.ZodError) {
      return res.status(400).json({ error: 'Validation failed', details: err.errors });
    }
    return res.status(500).json({ error: err.message });
  }
}

export async function deleteFacility(req: AuthRequest, res: Response) {
  try {
    const { id } = req.params;
    const facility = await prisma.facility.delete({ where: { id } });

    await prisma.auditLog.create({
      data: {
        action: 'FACILITY_DELETED',
        adminEmail: req.user?.email || 'admin@yegnahealth.org',
        details: `Deleted youth facility: ${facility.nameEn}`,
      },
    });

    return res.json({ success: true, message: 'Facility deleted successfully.' });
  } catch (err: any) {
    return res.status(500).json({ error: err.message });
  }
}
