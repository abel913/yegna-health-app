import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../theme/app_glass_theme.dart';
import '../repositories/mentor_repository.dart';
import '../widgets/mentor_card.dart';
import '../widgets/mentors_ambient_backdrop.dart';
import '../widgets/mentors_empty_views.dart';
import '../widgets/mentors_filter_bar.dart';
import '../widgets/mentors_search_bar.dart';
import 'mentors_page_flow_mixin.dart';

class MentorsPage extends StatefulWidget {
  const MentorsPage({
    this.mentorRepository,
    super.key,
  });

  final MentorRepository? mentorRepository;

  @override
  State<MentorsPage> createState() => _MentorsPageState();
}

class _MentorsPageState extends State<MentorsPage> with MentorsPageFlowMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final glass = context.glassTheme;
    final isDark = glass.isDark;
    final isAmharic = Localizations.localeOf(context).languageCode == 'am';

    if (!isLoading &&
        mentors.isEmpty &&
        searchController.text.isEmpty &&
        selectedCampus == 'all' &&
        repository is UnconfiguredMentorRepository) {
      return MentorsUnconfiguredView(l10n: l10n, glass: glass);
    }

    return Stack(
      children: [
        MentorsAmbientBackdrop(isDark: isDark),
        LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth > 720 ? 680.0 : 560.0;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MentorsSearchBar(
                      controller: searchController,
                      glass: glass,
                      isDark: isDark,
                      l10n: l10n,
                    ),
                    MentorsFilterBar(
                      l10n: l10n,
                      glass: glass,
                      isDark: isDark,
                      isAmharic: isAmharic,
                      selectedCampus: selectedCampus,
                      mentorsCount: mentors.length,
                      onCampusSelected: selectCampus,
                      onClearFilter: () => selectCampus('all'),
                    ),
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: glass.accentColor,
                              ),
                            )
                          : mentors.isEmpty
                              ? MentorsNoResultsView(
                                  l10n: l10n,
                                  glass: glass,
                                  onResetFilters: resetFilters,
                                )
                              : RefreshIndicator(
                                  onRefresh: () =>
                                      loadMentors(forceRefresh: true),
                                  color: glass.accentColor,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 6, 20, 24),
                                    itemCount: mentors.length,
                                    itemBuilder: (context, index) => MentorCard(
                                      mentor: mentors[index],
                                    ),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
