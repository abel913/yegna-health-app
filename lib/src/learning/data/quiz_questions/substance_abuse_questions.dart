import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kSubstanceAbuseQuizQuestions = [
  // 1. Definition & Nature of Addiction (True / False)
  QuizQuestionModel(
    id: 'substance-q1',
    category: (l10n) => l10n.substanceDefTitle,
    questionText: (l10n) => l10n.substanceQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.substanceQ1Insight,
  ),
  // 2. Substance Categories (Multiple Choice)
  QuizQuestionModel(
    id: 'substance-q2',
    category: (l10n) => l10n.substanceTypesTitle,
    questionText: (l10n) => l10n.substanceQ2Text,
    options: [
      (l10n) => l10n.substanceQ2OptA,
      (l10n) => l10n.substanceQ2OptB,
      (l10n) => l10n.substanceQ2OptC,
      (l10n) => l10n.substanceQ2OptD,
    ],
    correctIndex: 0, // OptA: Depressants
    insight: (l10n) => l10n.substanceQ2Insight,
  ),
  // 3. Tolerance & Dependency (Multiple Choice)
  QuizQuestionModel(
    id: 'substance-q3',
    category: (l10n) => l10n.substanceSignsTitle,
    questionText: (l10n) => l10n.substanceQ3Text,
    options: [
      (l10n) => l10n.substanceQ3OptA,
      (l10n) => l10n.substanceQ3OptB,
      (l10n) => l10n.substanceQ3OptC,
      (l10n) => l10n.substanceQ3OptD,
    ],
    correctIndex: 0,
    insight: (l10n) => l10n.substanceQ3Insight,
  ),
  // 4. Support Pathways & Recovery (True / False)
  QuizQuestionModel(
    id: 'substance-q4',
    category: (l10n) => l10n.substanceEffectsTitle,
    questionText: (l10n) => l10n.substanceQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.substanceQ4Insight,
  ),
];
