import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kHivQuizQuestions = [
  // 1. Definition (True / False)
  QuizQuestionModel(
    id: 'hiv-q1',
    category: (l10n) => l10n.hivDefinitionTitle,
    questionText: (l10n) => l10n.hivQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.hivQ1Insight,
  ),
  // 2. Mode of Transmission (Multiple Choice)
  QuizQuestionModel(
    id: 'hiv-q2',
    category: (l10n) => l10n.hivTransmissionTitle,
    questionText: (l10n) => l10n.hivQ2Text,
    options: [
      (l10n) => l10n.hivQ2OptA,
      (l10n) => l10n.hivQ2OptB,
      (l10n) => l10n.hivQ2OptC,
      (l10n) => l10n.hivQ2OptD,
    ],
    correctIndex: 3, // A & B
    insight: (l10n) => l10n.hivQ2Insight,
  ),
  // 3. Emergency PEP (Multiple Choice)
  QuizQuestionModel(
    id: 'hiv-q4',
    category: (l10n) => l10n.hivPreventionTitle,
    questionText: (l10n) => l10n.hivQ4Text,
    options: [
      (l10n) => l10n.hivQ4OptA,
      (l10n) => l10n.hivQ4OptB,
      (l10n) => l10n.hivQ4OptC,
      (l10n) => l10n.hivQ4OptD,
    ],
    correctIndex: 1, // 72 hours
    insight: (l10n) => l10n.hivQ4Insight,
  ),
  // 4. Treatment & ART U=U (True / False)
  QuizQuestionModel(
    id: 'hiv-q6',
    category: (l10n) => l10n.treatmentForHivPositive,
    questionText: (l10n) => l10n.hivQ6Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.hivQ6Insight,
  ),
];
