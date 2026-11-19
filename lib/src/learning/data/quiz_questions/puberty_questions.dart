import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kPubertyQuizQuestions = [
  // 1. Natural Biological Variation (True / False)
  QuizQuestionModel(
    id: 'puberty-q1',
    category: (l10n) => l10n.pubertySection1Title,
    questionText: (l10n) => l10n.pubertyQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.pubertyQ1Insight,
  ),
  // 2. Male Pubertal Changes (Multiple Choice)
  QuizQuestionModel(
    id: 'puberty-q2',
    category: (l10n) => l10n.pubertySection2Title,
    questionText: (l10n) => l10n.pubertyQ2Text,
    options: [
      (l10n) => l10n.pubertyQ2OptA,
      (l10n) => l10n.pubertyQ2OptB,
      (l10n) => l10n.pubertyQ2OptC,
      (l10n) => l10n.pubertyQ2OptD,
    ],
    correctIndex: 0, // OptA: Deepening of voice and growth of hair
    insight: (l10n) => l10n.pubertyQ2Insight,
  ),
  // 3. Menstrual Hygiene Practice (Multiple Choice)
  QuizQuestionModel(
    id: 'puberty-q3',
    category: (l10n) => l10n.pubertySection4Title,
    questionText: (l10n) => l10n.pubertyQ3Text,
    options: [
      (l10n) => l10n.pubertyQ3OptA,
      (l10n) => l10n.pubertyQ3OptB,
      (l10n) => l10n.pubertyQ3OptC,
      (l10n) => l10n.pubertyQ3OptD,
    ],
    correctIndex: 0,
    insight: (l10n) => l10n.pubertyQ3Insight,
  ),
  // 4. Emotional Changes & Support (True / False)
  QuizQuestionModel(
    id: 'puberty-q4',
    category: (l10n) => l10n.pubertySection3Title,
    questionText: (l10n) => l10n.pubertyQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.pubertyQ4Insight,
  ),
];
