import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

class UogCampus {
  const UogCampus({
    required this.id,
    required this.nameEn,
    required this.nameAm,
    required this.icon,
    this.coordinates,
  });

  final String id;
  final String nameEn;
  final String nameAm;
  final IconData icon;
  final LatLng? coordinates;

  String localizedName(bool isAmharic) => isAmharic ? nameAm : nameEn;
}

const List<UogCampus> kUogCampuses = [
  UogCampus(
    id: 'all',
    nameEn: 'All Campuses',
    nameAm: 'ሁሉም ግቢዎች',
    icon: Icons.hub_rounded,
    coordinates: LatLng(12.6075, 37.4589),
  ),
  UogCampus(
    id: 'Atse Fasil Campus',
    nameEn: 'Atse Fasil Campus',
    nameAm: 'አጼ ፋሲል ግቢ',
    icon: Icons.architecture_rounded,
    coordinates: LatLng(12.6135, 37.4720),
  ),
  UogCampus(
    id: 'Atse Tewodros Campus',
    nameEn: 'Atse Tewodros Campus',
    nameAm: 'አጼ ቴዎድሮስ ግቢ',
    icon: Icons.biotech_rounded,
    coordinates: LatLng(12.6033, 37.4542),
  ),
  UogCampus(
    id: 'CMHS / Health College',
    nameEn: 'CMHS / Health Sciences College',
    nameAm: 'የጤና ሳይንስ ኮሌጅ ግቢ',
    icon: Icons.medical_services_rounded,
    coordinates: LatLng(12.6092, 37.4611),
  ),
  UogCampus(
    id: 'Maraki Campus',
    nameEn: 'Maraki Campus',
    nameAm: 'ማራኪ ግቢ',
    icon: Icons.account_balance_rounded,
    coordinates: LatLng(12.6075, 37.4589),
  ),
  UogCampus(
    id: 'Teda Campus',
    nameEn: 'Teda Campus',
    nameAm: 'ተዳ ግቢ',
    icon: Icons.agriculture_rounded,
    coordinates: LatLng(12.5312, 37.4728),
  ),
];
