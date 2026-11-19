import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kGbvQuizQuestions = [
  // 1. Definition & Scope of GBV (True / False)
  QuizQuestionModel(
    id: 'gbv-q1',
    category: (l10n) => l10n.gbvSection1Title,
    questionText: (l10n) => l10n.gbvQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.gbvQ1Insight,
  ),
  // 2. Immediate Survivor Care (Multiple Choice)
  QuizQuestionModel(
    id: 'gbv-q2',
    category: (l10n) => l10n.gbvSection4Title,
    questionText: (l10n) => l10n.gbvQ2Text,
    options: [
      (l10n) => l10n.gbvQ2OptA,
      (l10n) => l10n.gbvQ2OptB,
      (l10n) => l10n.gbvQ2OptC,
      (l10n) => l10n.gbvQ2OptD,
    ],
    correctIndex: 0,
    insight: (l10n) => l10n.gbvQ2Insight,
  ),
  // 3. Engaging Men and Boys (Multiple Choice)
  QuizQuestionModel(
    id: 'gbv-q3',
    category: (l10n) => l10n.gbvSection4Title,
    questionText: (l10n) => l10n.gbvQ3Text,
    options: [
      (l10n) => l10n.gbvQ3OptA,
      (l10n) => l10n.gbvQ3OptB,
      (l10n) => l10n.gbvQ3OptC,
      (l10n) => l10n.gbvQ3OptD,
    ],
    correctIndex: 0,
    insight: (l10n) => l10n.gbvQ3Insight,
  ),
  // 4. Zero Tolerance & No Blame (True / False)
  QuizQuestionModel(
    id: 'gbv-q4',
    category: (l10n) => l10n.gbvSection3Title,
    questionText: (l10n) => l10n.gbvQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.gbvQ4Insight,
  ),
];
