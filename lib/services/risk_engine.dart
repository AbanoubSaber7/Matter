import '../models/risk_assessment.dart';

class RiskEngine {
  static const List<String> criticalKeywords = [
    'انتحار', 'أقتل نفسي', 'أنهي حياتي', 'أذبح نفسي', 'أنتحر', 'انتحاري', 'نفسي تموت', 'عايز أموت',
    'suicide', 'kill myself', 'end my life', 'want to die', 'die', 'إنهاء حياتي', 'انهاء حياتي', 'بنهي حياتي'
  ];

  static const List<String> highKeywords = [
    'تعبت من الحياة', 'كرهت نفسي', 'وجع كبير', 'مكتئب جدا', 'مخفوق',
    'depression', 'depressed', 'self harm', 'hurt myself', 'hopeless',
  ];

  static RiskAssessment analyzeText(String text) {
    String lowerText = text.toLowerCase();
    
    // 1. فحص الكلمات الحرجة جداً
    for (var word in criticalKeywords) {
      if (lowerText.contains(word)) {
        return RiskAssessment(
          level: RiskLevel.critical,
          confidence: 100.0,
          reason: "تم رصد كلمات تشير لخطر حرج على السلامة الشخصية.",
          detectedKeywords: [word],
          recommendations: [
            "اتصل بالخط الساخن للصحة النفسية فوراً",
            "تحدث مع شخص تثق به الآن",
            "توجه لأقرب مستشفى إذا لزم الأمر"
          ],
          originalText: text,
        );
      }
    }

    // 2. فحص الكلمات عالية الخطورة
    for (var word in highKeywords) {
      if (lowerText.contains(word)) {
        return RiskAssessment(
          level: RiskLevel.high,
          confidence: 80.0,
          reason: "النص يحتوي على مؤشرات قوية للحزن أو الاكتئاب.",
          detectedKeywords: [word],
          recommendations: [
            "حاول ممارسة تمارين التنفس",
            "تحدث مع رفيقك الذكي عن مشاعرك بالتفصيل",
            "لا تتردد في طلب دعم من المختصين"
          ],
          originalText: text,
        );
      }
    }

    return RiskAssessment(
      level: RiskLevel.low,
      confidence: 0.0,
      reason: "رسالة عادية.",
      detectedKeywords: [],
      recommendations: ["استمر في الاعتناء بنفسك", "جرب تمارين اليقظة الذهنية"],
      originalText: text,
    );
  }
}
