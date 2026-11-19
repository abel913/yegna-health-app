import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class QuizRunnerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuizRunnerAppBar({
    required this.titleText,
    required this.onBack,
    super.key,
  });

  final String titleText;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF4F9FD),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF005A71),
          size: 24,
        ),
        onPressed: onBack,
      ),
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF005A71),
              fontSize: 18,
            ),
      ),
    );
  }
}

class QuizHeaderBar extends StatelessWidget {
  const QuizHeaderBar({
    required this.currentIndex,
    required this.total,
    required this.categoryText,
    required this.l10n,
    super.key,
  });

  final int currentIndex;
  final int total;
  final String categoryText;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEEFA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  l10n.questionProgress(currentIndex + 1, total),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF005A71),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Spacer(),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD6E4F0)),
                  ),
                  child: Text(
                    categoryText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: List.generate(total, (i) {
              final isFilled = i <= currentIndex;
              return Expanded(
                child: Container(
                  height: 4.5,
                  margin: EdgeInsets.only(right: i < total - 1 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: isFilled
                        ? const Color(0xFF0284C7)
                        : const Color(0xFFD6E4F0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
