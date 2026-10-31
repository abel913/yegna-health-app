import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class MentorsPage extends StatelessWidget {
  const MentorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _DirectoryPage(
      icon: Icons.people_alt_outlined,
      title: l10n.mentorsTab,
      introduction: l10n.mentorsIntroduction,
      searchLabel: l10n.searchMentors,
      filters: [l10n.allMentors, l10n.languageFilter],
      emptyTitle: l10n.noVerifiedMentorsTitle,
      emptyBody: l10n.noVerifiedMentorsBody,
      footerIcon: Icons.shield_outlined,
      footerTitle: l10n.mentorSafetyTitle,
      footerBody: l10n.mentorSafetyBody,
    );
  }
}

class FacilitiesPage extends StatelessWidget {
  const FacilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _DirectoryPage(
      icon: Icons.local_hospital_outlined,
      title: l10n.facilitiesTab,
      introduction: l10n.facilitiesIntroduction,
      searchLabel: l10n.searchFacilities,
      filters: [l10n.allFacilities, l10n.nearbyFilter, l10n.campusFilter],
      emptyTitle: l10n.noVerifiedFacilitiesTitle,
      emptyBody: l10n.facilitiesNotAvailableBody,
      footerIcon: Icons.map_outlined,
      footerTitle: l10n.mapPreviewTitle,
      footerBody: l10n.mapNotAvailableBody,
    );
  }
}

class _DirectoryPage extends StatelessWidget {
  const _DirectoryPage({
    required this.icon,
    required this.title,
    required this.introduction,
    required this.searchLabel,
    required this.filters,
    required this.emptyTitle,
    required this.emptyBody,
    required this.footerIcon,
    required this.footerTitle,
    required this.footerBody,
  });

  final IconData icon;
  final String title;
  final String introduction;
  final String searchLabel;
  final List<String> filters;
  final String emptyTitle;
  final String emptyBody;
  final IconData footerIcon;
  final String footerTitle;
  final String footerBody;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final contentWidth = constraints.maxWidth > 720 ? 680.0 : 560.0;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF0FF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: const Color(0xFFDBF3F8),
                              child: Icon(icon, color: const Color(0xFF005A71)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(introduction,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        constraints: const BoxConstraints(minHeight: 52),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(searchLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (var index = 0; index < filters.length; index++)
                            Chip(
                              avatar: index == 0
                                  ? Icon(Icons.check,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary)
                                  : null,
                              label: Text(filters[index]),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerLow,
                              side: BorderSide.none,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: const Color(0xFFE4E9FF),
                                child: Icon(icon,
                                    size: 25, color: const Color(0xFF005A71)),
                              ),
                              const SizedBox(height: 14),
                              Text(emptyTitle,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(emptyBody,
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        child: ListTile(
                          leading:
                              Icon(footerIcon, color: const Color(0xFF005A71)),
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 14),
                          title: Text(footerTitle),
                          subtitle: Text(footerBody),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
}
