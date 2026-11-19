import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kStiQuizQuestions = [
  // 1. Asymptomatic Nature & Screening (True / False)
  QuizQuestionModel(
    id: 'sti-q1',
    category: (l10n) => l10n.stiDefinitionTitle,
    questionText: (l10n) => l10n.stiQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.stiQ1Insight,
  ),
  // 2. Prevention & Barrier Methods (Multiple Choice)
  QuizQuestionModel(
    id: 'sti-q2',
    category: (l10n) => l10n.stiPreventionTitle,
    questionText: (l10n) => l10n.stiQ2Text,
    options: [
      (l10n) => l10n.stiQ2OptA,
      (l10n) => l10n.stiQ2OptB,
      (l10n) => l10n.stiQ2OptC,
      (l10n) => l10n.stiQ2OptD,
    ],
    correctIndex: 0,
    insight: (l10n) => l10n.stiQ2Insight,
  ),
  // 3. Treatment Adherence (Multiple Choice)
  QuizQuestionModel(
    id: 'sti-q3',
    category: (l10n) => l10n.stiTreatmentTitle,
    questionText: (l10n) => l10n.stiQ3Text,
    options: [
      (l10n) => l10n.stiQ3OptA,
      (l10n) => l10n.stiQ3OptB,
      (l10n) => l10n.stiQ3OptC,
      (l10n) => l10n.stiQ3OptD,
    ],
    correctIndex: 0,
    insight: (l10n) => l10n.stiQ3Insight,
  ),
  // 4. Partner Notification & Treatment (True / False)
  QuizQuestionModel(
    id: 'sti-q4',
    category: (l10n) => l10n.stiComplicationsTitle,
    questionText: (l10n) => l10n.stiQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.stiQ4Insight,
  ),
];
