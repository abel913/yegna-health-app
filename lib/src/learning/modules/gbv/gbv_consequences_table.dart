import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

/// Styled consequence table matching the reference poster graphic.
class GbvConsequencesTable extends StatelessWidget {
  const GbvConsequencesTable({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final rows = [
      [l10n.gbvTablePhys1, l10n.gbvTablePsych1, l10n.gbvTableSoc1],
      [l10n.gbvTablePhys2, l10n.gbvTablePsych2, l10n.gbvTableSoc2],
      [l10n.gbvTablePhys3, l10n.gbvTablePsych3, l10n.gbvTableSoc3],
      [l10n.gbvTablePhys4, l10n.gbvTablePsych4, l10n.gbvTableSoc4],
      [l10n.gbvTablePhys5, l10n.gbvTablePsych5, l10n.gbvTableSoc5],
      [l10n.gbvTablePhys6, l10n.gbvTablePsych6, l10n.gbvTableSoc6],
      [l10n.gbvTablePhys7, '—', l10n.gbvTableSoc7],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2D9C8),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              l10n.gbvTableTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E3A8A),
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Table(
              border: TableBorder.all(
                color: const Color(0xFFCBD5E1),
                width: 0.9,
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.15),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color(0xFF581C87),
                  ),
                  children: [
                    _buildHeaderCell(l10n.gbvTableColPhysical),
                    _buildHeaderCell(l10n.gbvTableColPsychological),
                    _buildHeaderCell(l10n.gbvTableColSocial),
                  ],
                ),
                for (var i = 0; i < rows.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: i.isEven ? Colors.white : const Color(0xFFF8FAFC),
                    ),
                    children: [
                      _buildDataCell(rows[i][0]),
                      _buildDataCell(rows[i][1]),
                      _buildDataCell(rows[i][2]),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: const Color(0xFF0284C7),
                  width: 1,
                ),
              ),
              child: const Text(
                'GENDER BASED VIOLENCE',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0284C7),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11.5,
          color: Color(0xFF1E293B),
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    );
  }
}
