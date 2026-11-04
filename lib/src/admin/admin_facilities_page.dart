import 'package:flutter/material.dart';

import '../discovery/facility_model.dart';
import '../theme/app_glass_theme.dart';
import 'admin_controller.dart';
import 'content_templates.dart';

class AdminFacilitiesPage extends StatefulWidget {
  const AdminFacilitiesPage({
    required this.controller,
    super.key,
  });

  final AdminController controller;

  @override
  State<AdminFacilitiesPage> createState() => _AdminFacilitiesPageState();
}

class _AdminFacilitiesPageState extends State<AdminFacilitiesPage> {
  void _openFacilityEditor([Facility? initial]) {
    final isEditing = initial != null;
    final idController = TextEditingController(
      text: initial?.id ?? 'fac_${DateTime.now().millisecondsSinceEpoch}',
    );
    final nameEn = TextEditingController(text: initial?.nameEn ?? '');
    final nameAm = TextEditingController(text: initial?.nameAm ?? '');
    final subCityEn = TextEditingController(text: initial?.subCityEn ?? 'Bole');
    final subCityAm = TextEditingController(text: initial?.subCityAm ?? 'ቦሌ');
    final addressEn = TextEditingController(text: initial?.addressEn ?? '');
    final addressAm = TextEditingController(text: initial?.addressAm ?? '');
    final phone =
        TextEditingController(text: initial?.phone ?? '+251-11-662-8899');
    final lat =
        TextEditingController(text: initial?.latitude.toString() ?? '9.0123');
    final lng =
        TextEditingController(text: initial?.longitude.toString() ?? '38.7634');

    FacilityType selectedType = initial?.type ?? FacilityType.youthCenter;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final glass = ctx.glassTheme;
          return AlertDialog(
            backgroundColor: glass.modalBackground,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? 'Edit Health Facility' : 'Add Health Facility',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: glass.titleText,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                  label: const Text('Template', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    final t = ContentTemplates.facilityTemplates.first;
                    setDialogState(() {
                      nameEn.text = t.nameEn;
                      nameAm.text = t.nameAm;
                      subCityEn.text = t.subCityEn;
                      subCityAm.text = t.subCityAm;
                      addressEn.text = t.addressEn;
                      addressAm.text = t.addressAm;
                      phone.text = t.phone;
                      lat.text = t.latitude.toString();
                      lng.text = t.longitude.toString();
                      selectedType = t.type;
                    });
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: 520,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameEn,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Facility Name (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameAm,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'የጤና ጣቢያው ስም (አማርኛ)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subCityEn,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Sub-City (English)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: phone,
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: addressEn,
                      style: TextStyle(fontSize: 13.5, color: glass.titleText),
                      decoration: const InputDecoration(
                        labelText: 'Full Address (English)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: lat,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Latitude (GPS)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: lng,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            style: TextStyle(
                                fontSize: 13.5, color: glass.titleText),
                            decoration: const InputDecoration(
                              labelText: 'Longitude (GPS)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (nameEn.text.trim().isEmpty) return;
                  final fac = Facility(
                    id: idController.text.trim(),
                    nameEn: nameEn.text.trim(),
                    nameAm: nameAm.text.trim().isNotEmpty
                        ? nameAm.text.trim()
                        : nameEn.text.trim(),
                    subCityEn: subCityEn.text.trim(),
                    subCityAm: subCityAm.text.trim().isNotEmpty
                        ? subCityAm.text.trim()
                        : subCityEn.text.trim(),
                    addressEn: addressEn.text.trim(),
                    addressAm: addressAm.text.trim().isNotEmpty
                        ? addressAm.text.trim()
                        : addressEn.text.trim(),
                    landmarkEn: 'Main Road',
                    landmarkAm: 'ዋና መንገድ',
                    phone: phone.text.trim(),
                    type: selectedType,
                    latitude: double.tryParse(lat.text.trim()) ?? 9.0123,
                    longitude: double.tryParse(lng.text.trim()) ?? 38.7634,
                    distanceKm: initial?.distanceKm ?? 1.5,
                    isYouthFriendly: true,
                    isFreeForYouth: true,
                    openingHour: initial?.openingHour ?? 8,
                    closingHour: initial?.closingHour ?? 18,
                    services: initial?.services ??
                        const ['SRH Services', 'VCT / HIV Testing'],
                  );
                  await widget.controller.saveFacility(fac);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Save Facility'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final glass = context.glassTheme;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    return Scaffold(
      backgroundColor: glass.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: glass.appBarBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: glass.titleText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isAmharic ? 'የጤና ተቋማት ማስተዳደሪያ' : 'Manage Health Facilities',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: glass.titleText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: Color(0xFF38BDF8)),
            tooltip: 'Add Facility',
            onPressed: () => _openFacilityEditor(),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final facilities = widget.controller.facilities;
          if (facilities.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_hospital_rounded,
                      size: 48, color: Color(0xFF38BDF8)),
                  const SizedBox(height: 12),
                  Text(
                    'No facilities registered yet.',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: glass.titleText),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Facility'),
                    onPressed: () => _openFacilityEditor(),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: facilities.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final f = facilities[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: glass.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: glass.cardBorder, width: 1.2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.local_hospital_rounded,
                          color: Color(0xFF38BDF8), size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAmharic ? f.nameAm : f.nameEn,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: glass.titleText,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            isAmharic ? f.subCityAm : f.subCityEn,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: glass.subtitleText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📞 ${f.phone} • 📍 (${f.latitude.toStringAsFixed(3)}, ${f.longitude.toStringAsFixed(3)})',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      tooltip: 'Edit',
                      onPressed: () => _openFacilityEditor(f),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 20, color: Color(0xFFEF4444)),
                      tooltip: 'Delete',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Facility?'),
                            content: Text(
                                'Are you sure you want to remove "${f.nameEn}"?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4444),
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await widget.controller.deleteFacility(f.id);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
