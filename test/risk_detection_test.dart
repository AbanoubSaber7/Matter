// test/risk_detection_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:you_matter_app/models/risk_assessment.dart';
import 'package:you_matter_app/services/risk_engine.dart';

void main() {
  group('RiskEngine - Advanced Risk Detection Tests', () {
    
    // اختبارات الخطر الحرج
    group('Critical Risk Tests', () {
      test('Should detect suicide keywords', () {
        final assessment = RiskEngine.analyzeText('أنا أريد أن أنهي حياتي');
        expect(assessment.level, equals(RiskLevel.critical));
        expect(assessment.confidence, greaterThanOrEqualTo(50));
      });

      test('Should detect self-harm keywords', () {
        final assessment = RiskEngine.analyzeText('سأأذي نفسي الآن');
        expect(assessment.level, equals(RiskLevel.critical));
      });

      test('Should detect multiple critical keywords', () {
        final assessment = RiskEngine.analyzeText('أريد الانتحار لأنني لا أستطيع تحمل الألم');
        expect(assessment.level, equals(RiskLevel.critical));
        expect(assessment.detectedKeywords.length, greaterThan(0));
      });

      test('Should handle English critical keywords', () {
        final assessment = RiskEngine.analyzeText('I want to kill myself');
        expect(assessment.level, equals(RiskLevel.critical));
      });

      test('Should detect overdose references', () {
        final assessment = RiskEngine.analyzeText('سأتناول جرعة زائدة من الأدوية');
        expect(assessment.level, equals(RiskLevel.critical));
      });
    });

    // اختبارات الخطر العالي
    group('High Risk Tests', () {
      test('Should detect high-risk hopelessness', () {
        final assessment = RiskEngine.analyzeText('أنا يائس ولا أرى أي أمل');
        expect(assessment.level, equals(RiskLevel.high));
      });

      test('Should detect self-harm thoughts', () {
        final assessment = RiskEngine.analyzeText('أريد أن أؤذي نفسي');
        expect(assessment.level, equals(RiskLevel.high));
      });

      test('Should detect worthlessness', () {
        final assessment = RiskEngine.analyzeText('أنا بلا قيمة وعبء على الجميع');
        expect(assessment.level, equals(RiskLevel.high));
      });

      test('Should detect loneliness and isolation', () {
        final assessment = RiskEngine.analyzeText('أنا وحيد جداً ولا أحد يفهمني');
        expect(assessment.level, equals(RiskLevel.high));
      });
    });

    // اختبارات الخطر المتوسط
    group('Medium Risk Tests', () {
      test('Should detect anxiety', () {
        final assessment = RiskEngine.analyzeText('أنا قلق جداً بشأن المستقبل');
        expect(assessment.level, equals(RiskLevel.medium));
      });

      test('Should detect stress and exhaustion', () {
        final assessment = RiskEngine.analyzeText('أنا متعب جداً ومجهد من العمل');
        expect(assessment.level, equals(RiskLevel.medium));
      });

      test('Should detect sadness', () {
        final assessment = RiskEngine.analyzeText('أشعر بحزن شديد هذه الأيام');
        expect(assessment.level, equals(RiskLevel.medium));
      });

      test('Should detect crying and tears', () {
        final assessment = RiskEngine.analyzeText('أبكي كثيراً والدموع لا تتوقف');
        expect(assessment.level, equals(RiskLevel.medium));
      });
    });

    // اختبارات الخطر المنخفض
    group('Low Risk Tests', () {
      test('Should classify normal message as low risk', () {
        final assessment = RiskEngine.analyzeText('كيف حالك اليوم؟');
        expect(assessment.level, equals(RiskLevel.low));
      });

      test('Should classify positive message as low risk', () {
        final assessment = RiskEngine.analyzeText('أشعر بتحسن كبير، شكراً لك');
        expect(assessment.level, equals(RiskLevel.low));
      });

      test('Should classify hopeful message as low risk', () {
        final assessment = RiskEngine.analyzeText('أنا متفائل بالمستقبل وأحب الحياة');
        expect(assessment.level, equals(RiskLevel.low));
      });

      test('Should handle empty message', () {
        final assessment = RiskEngine.analyzeText('');
        expect(assessment.level, equals(RiskLevel.low));
        expect(assessment.confidence, equals(100));
      });
    });

    // اختبارات التوازن (موجب + سلبي)
    group('Balanced Message Tests', () {
      test('Should reduce risk with positive keywords', () {
        final assessment1 = RiskEngine.analyzeText('أنا حزين');
        final assessment2 = RiskEngine.analyzeText('كنت حزيناً لكنني بتحسن الآن');
        
        expect(assessment2.level.index, lessThanOrEqualTo(assessment1.level.index));
      });

      test('Should handle mixed messages', () {
        final assessment = RiskEngine.analyzeText('أشعر بألم لكنني آمل أن يتحسن الحال');
        // يجب أن يكون هناك توازن
        expect(assessment.level, isNotNull);
      });
    });

    // اختبارات درجة الثقة
    group('Confidence Score Tests', () {
      test('Should have high confidence with multiple keywords', () {
        final assessment = RiskEngine.analyzeText('أنا يائس وحيد بلا أمل وأكره الحياة');
        expect(assessment.confidence, greaterThan(70));
      });

      test('Should have lower confidence with single keyword', () {
        final assessment = RiskEngine.analyzeText('أشعر بقلق');
        expect(assessment.confidence, lessThan(70));
      });

      test('Confidence should be between 0-100', () {
        final messages = [
          'مرحبا',
          'أنا حزين',
          'أريد الانتحار',
          'كل شيء بخير',
          'أنا متعب'
        ];
        
        for (final msg in messages) {
          final assessment = RiskEngine.analyzeText(msg);
          expect(assessment.confidence, greaterThanOrEqualTo(0));
          expect(assessment.confidence, lessThanOrEqualTo(100));
        }
      });
    });

    // اختبارات الكلمات المفتاحية المكتشفة
    group('Detected Keywords Tests', () {
      test('Should detect and list keywords', () {
        final assessment = RiskEngine.analyzeText('أنا حزين وقلق');
        expect(assessment.detectedKeywords.isNotEmpty, true);
        expect(assessment.detectedKeywords.length, greaterThan(0));
      });

      test('Should not have duplicate keywords', () {
        final assessment = RiskEngine.analyzeText('حزين حزين حزين');
        final keywords = assessment.detectedKeywords;
        final uniqueKeywords = keywords.toSet();
        expect(keywords.length, equals(uniqueKeywords.length));
      });

      test('Should handle case insensitivity', () {
        final assessment1 = RiskEngine.analyzeText('SUICIDE');
        final assessment2 = RiskEngine.analyzeText('suicide');
        expect(assessment1.level, equals(assessment2.level));
      });
    });

    // اختبارات التوصيات
    group('Recommendations Tests', () {
      test('Critical level should have specific recommendations', () {
        final assessment = RiskEngine.analyzeText('أريد أن أنهي حياتي');
        expect(assessment.recommendations.isNotEmpty, true);
        expect(assessment.recommendations.length, greaterThan(0));
      });

      test('Each risk level should have recommendations', () {
        final lowAssessment = RiskEngine.analyzeText('مرحبا');
        final mediumAssessment = RiskEngine.analyzeText('أنا قلق');
        final highAssessment = RiskEngine.analyzeText('أنا يائس');
        
        expect(lowAssessment.recommendations.isNotEmpty, true);
        expect(mediumAssessment.recommendations.isNotEmpty, true);
        expect(highAssessment.recommendations.isNotEmpty, true);
      });
    });

    // اختبارات سبب التصنيف
    group('Reason Generation Tests', () {
      test('Should generate appropriate reason for each level', () {
        final critical = RiskEngine.analyzeText('أريد الانتحار');
        final high = RiskEngine.analyzeText('أنا يائس');
        final medium = RiskEngine.analyzeText('أنا قلق');
        final low = RiskEngine.analyzeText('مرحبا');
        
        expect(critical.reason.isNotEmpty, true);
        expect(high.reason.isNotEmpty, true);
        expect(medium.reason.isNotEmpty, true);
        expect(low.reason.isNotEmpty, true);
      });
    });

    // اختبارات نموذج RiskAssessment
    group('RiskAssessment Model Tests', () {
      test('Should convert to map', () {
        final assessment = RiskEngine.analyzeText('أنا حزين');
        final map = assessment.toMap();
        
        expect(map.containsKey('level'), true);
        expect(map.containsKey('confidence'), true);
        expect(map.containsKey('reason'), true);
        expect(map.containsKey('detectedKeywords'), true);
        expect(map.containsKey('recommendations'), true);
        expect(map.containsKey('timestamp'), true);
      });

      test('Should create from map', () {
        final assessment1 = RiskEngine.analyzeText('أنا قلق');
        final map = assessment1.toMap();
        
        // محاكاة قراءة من Firestore
        map['originalText'] = 'أنا قلق';
        final assessment2 = RiskAssessment.fromMap(map);
        
        expect(assessment2.level, equals(assessment1.level));
        expect(assessment2.confidence, equals(assessment1.confidence));
      });
    });

    // اختبارات الأداء
    group('Performance Tests', () {
      test('Should analyze message quickly', () {
        final stopwatch = Stopwatch()..start();
        RiskEngine.analyzeText('أنا أشعر بقلق وحزن');
        stopwatch.stop();
        
        // يجب أن يكون التحليل أقل من 100 ميلي ثانية
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('Should handle long messages', () {
        final longMessage = 'أنا حزين ' * 100; // رسالة طويلة جداً
        final assessment = RiskEngine.analyzeText(longMessage);
        
        expect(assessment.level, isNotNull);
        expect(assessment.confidence, isNotNull);
      });
    });

    // اختبارات الحالات الحدية
    group('Edge Cases Tests', () {
      test('Should handle special characters', () {
        final assessment = RiskEngine.analyzeText('أنا حزين!!! @#$%');
        expect(assessment.level, isNotNull);
      });

      test('Should handle mixed language', () {
        final assessment = RiskEngine.analyzeText('أنا sad وحزين');
        expect(assessment.level, isNotNull);
      });

      test('Should handle repeated letters', () {
        final assessment = RiskEngine.analyzeText('أنا حزيييين جداااا');
        expect(assessment.level, isNotNull);
      });

      test('Should handle whitespace variations', () {
        final assessment1 = RiskEngine.analyzeText('أنا حزين');
        final assessment2 = RiskEngine.analyzeText('  أنا حزين  ');
        
        // يجب أن تكون النتائج متشابهة
        expect(assessment1.level, equals(assessment2.level));
      });
    });
  });
}
