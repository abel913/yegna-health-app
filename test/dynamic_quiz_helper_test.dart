import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/learning/dynamic_quiz_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DynamicQuizHelper Unit Tests', () {
    test('returns null when cached quizzes is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final result = await DynamicQuizHelper.loadFromCache(
        moduleId: 'module-01',
        category: 'puberty',
      );
      expect(result, isNull);
    });

    test('resolves both True/False and Multiple Choice questions dynamically from cache', () async {
      final mockQuizzes = [
        {
          'id': 'q_tf_1',
          'moduleId': 'module-01',
          'type': 'TRUE_FALSE',
          'questionEn': 'Puberty starts at the same age for everyone.',
          'questionAm': 'የጉርምስና ወቅት ለሁሉም በተመሳሳይ ዕድሜ ይጀምራል?',
          'optionsEn': ['True', 'False'],
          'optionsAm': ['እውነት', 'ሐሰት'],
          'correctIndex': 1,
          'explanationEn': 'Puberty timing naturally varies by genetics.',
          'explanationAm': 'የጉርምስና መጀመሪያ ዕድሜ እንደየግለሰቡ ይለያያል።',
          'module': {
            'titleEn': 'Understanding Puberty',
            'titleAm': 'የጉርምስና ወቅት',
            'category': 'puberty',
          },
        },
        {
          'id': 'q_mc_1',
          'moduleId': 'module-01',
          'type': 'MULTIPLE_CHOICE',
          'questionEn': 'Which physical change is common for boys?',
          'questionAm': 'በወንዶች ላይ የሚታየው ለውጥ የትኛው ነው?',
          'optionsEn': ['Voice deepening', 'Bone shrinking', 'Muscle loss', 'No sweat'],
          'optionsAm': ['ድምፅ መጎርነን', 'አጥንት መቀነስ', 'ጡንቻ መቀነስ', 'ላብ አለመኖር'],
          'correctIndex': 0,
          'explanationEn': 'Testosterone deepens vocal cords.',
          'explanationAm': 'ቴስቶስትሮን ድምፅ እንዲጎረንን ያደርጋል።',
          'module': {
            'titleEn': 'Understanding Puberty',
            'titleAm': 'የጉርምስና ወቅት',
            'category': 'puberty',
          },
        },
      ];

      SharedPreferences.setMockInitialValues({
        'yegna_offline_quizzes_v1': jsonEncode(mockQuizzes),
      });

      final questions = await DynamicQuizHelper.loadFromCache(
        moduleId: 'module-01',
        category: 'puberty',
      );

      expect(questions, isNotNull);
      expect(questions!.length, 2);

      // Question 1: True / False (2 options)
      final q1 = questions[0];
      expect(q1.id, 'q_tf_1');
      expect(q1.correctIndex, 1);
      expect(q1.options.length, 2);

      // Question 2: Multiple Choice (4 options)
      final q2 = questions[1];
      expect(q2.id, 'q_mc_1');
      expect(q2.correctIndex, 0);
      expect(q2.options.length, 4);
    });

    test('ignores non-matching modules', () async {
      final mockQuizzes = [
        {
          'id': 'q_srh_1',
          'moduleId': 'module-05',
          'type': 'TRUE_FALSE',
          'questionEn': 'SRH education is vital.',
          'questionAm': 'የስነ-ተዋልዶ ትምህርት አስፈላጊ ነው።',
          'optionsEn': ['True', 'False'],
          'optionsAm': ['እውነት', 'ሐሰት'],
          'correctIndex': 0,
          'explanationEn': 'Vital for health.',
          'explanationAm': 'ለጤና አስፈላጊ ነው።',
          'module': {
            'titleEn': 'Reproductive Health',
            'titleAm': 'የስነ-ተዋልዶ ጤና',
            'category': 'srh',
          },
        },
      ];

      SharedPreferences.setMockInitialValues({
        'yegna_offline_quizzes_v1': jsonEncode(mockQuizzes),
      });

      final questions = await DynamicQuizHelper.loadFromCache(
        moduleId: 'module-01',
        category: 'puberty',
      );

      expect(questions, isNull);
    });
  });
}
