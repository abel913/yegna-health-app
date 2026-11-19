import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kSrhQuizQuestions = [
  // 1. Holistic Definition of SRH (True / False)
  QuizQuestionModel(
    id: 'srh-q1',
    category: (l10n) => l10n.srhSection1Title,
    questionText: (l10n) => l10n.srhQ1Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.srhQ1Insight,
  ),
  // 2. Dual Protection & Barrier Methods (Multiple Choice)
  QuizQuestionModel(
    id: 'srh-q2',
    category: (l10n) => l10n.srhSection3Title,
    questionText: (l10n) => l10n.srhQ2Text,
    options: [
      (l10n) => l10n.srhQ2OptA,
      (l10n) => l10n.srhQ2OptB,
      (l10n) => l10n.srhQ2OptC,
      (l10n) => l10n.srhQ2OptD,
    ],
    correctIndex: 0, // OptA: External or internal condoms
    insight: (l10n) => l10n.srhQ2Insight,
  ),
  // 3. Mutual Consent & Bodily Autonomy (True / False)
  QuizQuestionModel(
    id: 'srh-q3',
    category: (l10n) => l10n.srhSection4Title,
    questionText: (l10n) => l10n.srhQ3Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.srhQ3Insight,
  ),
  // 4. Family Planning Benefits (True / False)
  QuizQuestionModel(
    id: 'srh-q4',
    category: (l10n) => l10n.srhSection3Title,
    questionText: (l10n) => l10n.srhQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.srhQ4Insight,
  ),
];
