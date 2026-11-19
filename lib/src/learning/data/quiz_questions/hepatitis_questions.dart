import '../../dynamic_quiz_helper.dart';

final List<QuizQuestionModel> kHepatitisQuizQuestions = [
  // 1. Organ Affected (Multiple Choice)
  QuizQuestionModel(
    id: 'hep-q1',
    category: (l10n) => l10n.hepatitisSection1Title,
    questionText: (l10n) => l10n.hepatitisQ1Text,
    options: [
      (l10n) => l10n.hepatitisQ1OptA,
      (l10n) => l10n.hepatitisQ1OptB,
      (l10n) => l10n.hepatitisQ1OptC,
      (l10n) => l10n.hepatitisQ1OptD,
    ],
    correctIndex: 0, // OptA: Liver
    insight: (l10n) => l10n.hepatitisQ1Insight,
  ),
  // 2. Hepatitis A & E Transmission (True / False)
  QuizQuestionModel(
    id: 'hep-q2',
    category: (l10n) => l10n.hepatitisSection2Title,
    questionText: (l10n) => l10n.hepatitisQ2Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.hepatitisQ2Insight,
  ),
  // 3. Prevention & Vaccination (Multiple Choice)
  QuizQuestionModel(
    id: 'hep-q3',
    category: (l10n) => l10n.hepatitisSection6Title,
    questionText: (l10n) => l10n.hepatitisQ3Text,
    options: [
      (l10n) => l10n.hepatitisQ3OptA,
      (l10n) => l10n.hepatitisQ3OptB,
      (l10n) => l10n.hepatitisQ3OptC,
      (l10n) => l10n.hepatitisQ3OptD,
    ],
    correctIndex: 0, // OptA: Hepatitis B vaccination and screening
    insight: (l10n) => l10n.hepatitisQ3Insight,
  ),
  // 4. Hepatitis C Curability (True / False)
  QuizQuestionModel(
    id: 'hep-q4',
    category: (l10n) => l10n.hepatitisSection5Title,
    questionText: (l10n) => l10n.hepatitisQ4Text,
    options: [
      (l10n) => l10n.trueOption,
      (l10n) => l10n.falseOption,
    ],
    correctIndex: 0, // True
    insight: (l10n) => l10n.hepatitisQ4Insight,
  ),
];
