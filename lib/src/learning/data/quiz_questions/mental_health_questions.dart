import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kMentalHealthQuizQuestions = [
  // 1. Mental vs Physical Health (True / False)
  QuizQuestionModel(
    id: 'mh-q1',
    category: (l10n) => l10n.mentalHealthSection1Title,
    questionText: (l10n) => l10n.mentalHealthQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.mentalHealthQ1Insight,
  ),
  // 2. Healthy Coping (Multiple Choice)
  QuizQuestionModel(
    id: 'mh-q2',
    category: (l10n) => l10n.mentalHealthSection3Title,
    questionText: (l10n) => l10n.mentalHealthQ2Text,
    options: [
      (l10n) => l10n.mentalHealthQ2OptA,
      (l10n) => l10n.mentalHealthQ2OptB,
      (l10n) => l10n.mentalHealthQ2OptC,
      (l10n) => l10n.mentalHealthQ2OptD,
    ],
    correctIndex: 0, // OptA
    insight: (l10n) => l10n.mentalHealthQ2Insight,
  ),
  // 3. Emotions Spectrum Myth-Busting (True / False)
  QuizQuestionModel(
    id: 'mh-q3',
    category: (l10n) => l10n.mentalHealthSection1Title,
    questionText: (l10n) => l10n.mentalHealthQ3Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 1, // False
    insight: (l10n) => l10n.mentalHealthQ3Insight,
  ),
  // 4. Seeking Support & Hotlines (Multiple Choice)
  QuizQuestionModel(
    id: 'mh-q4',
    category: (l10n) => l10n.mentalHealthSection4Title,
    questionText: (l10n) => l10n.mentalHealthQ4Text,
    options: [
      (l10n) => l10n.mentalHealthQ4OptA,
      (l10n) => l10n.mentalHealthQ4OptB,
      (l10n) => l10n.mentalHealthQ4OptC,
      (l10n) => l10n.mentalHealthQ4OptD,
    ],
    correctIndex: 0, // OptA
    insight: (l10n) => l10n.mentalHealthQ4Insight,
  ),
];
