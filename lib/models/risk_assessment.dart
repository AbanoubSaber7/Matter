// lib/models/risk_assessment.dart

/// مستويات الخطر في التطبيق
enum RiskLevel {
  /// لا يوجد خطر - رسالة عادية
  low,
  
  /// خطر منخفض - قد تشير إلى قلق أو ضغط نفسي بسيط
  medium,
  
  /// خطر عالي - تحتوي على كلمات خطرة أو إشارات لإيذاء النفس
  high,
  
  /// خطر حرج جداً - تحتوي على إشارات واضحة للانتحار أو الإيذاء الفوري
  critical,
}

/// نموذج نتائج تحليل المخاطر
class RiskAssessment {
  /// مستوى الخطر المكتشف
  final RiskLevel level;
  
  /// درجة الثقة في التحليل (0-100)
  final double confidence;
  
  /// سبب التصنيف
  final String reason;
  
  /// الكلمات المفتاحية التي تم اكتشافها
  final List<String> detectedKeywords;
  
  /// توصيات الإجراءات المقترحة
  final List<String> recommendations;
  
  /// الوقت الذي تم فيه التحليل
  final DateTime timestamp;
  
  /// النص الأصلي للرسالة
  final String originalText;

  RiskAssessment({
    required this.level,
    required this.confidence,
    required this.reason,
    required this.detectedKeywords,
    required this.recommendations,
    required this.originalText,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// إنشء نسخة معدلة من RiskAssessment
  RiskAssessment copyWith({
    RiskLevel? level,
    double? confidence,
    String? reason,
    List<String>? detectedKeywords,
    List<String>? recommendations,
    DateTime? timestamp,
    String? originalText,
  }) {
    return RiskAssessment(
      level: level ?? this.level,
      confidence: confidence ?? this.confidence,
      reason: reason ?? this.reason,
      detectedKeywords: detectedKeywords ?? this.detectedKeywords,
      recommendations: recommendations ?? this.recommendations,
      originalText: originalText ?? this.originalText,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  /// تحويل RiskAssessment إلى خريطة لحفظها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'level': level.toString(),
      'confidence': confidence,
      'reason': reason,
      'detectedKeywords': detectedKeywords,
      'recommendations': recommendations,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// إنشاء RiskAssessment من خريطة Firestore
  factory RiskAssessment.fromMap(Map<String, dynamic> map) {
    return RiskAssessment(
      level: RiskLevel.values.firstWhere(
        (e) => e.toString() == map['level'],
        orElse: () => RiskLevel.low,
      ),
      confidence: (map['confidence'] as num).toDouble(),
      reason: map['reason'] ?? '',
      detectedKeywords: List<String>.from(map['detectedKeywords'] ?? []),
      recommendations: List<String>.from(map['recommendations'] ?? []),
      originalText: map['originalText'] ?? '',
      timestamp: map['timestamp'] != null 
        ? DateTime.parse(map['timestamp']) 
        : DateTime.now(),
    );
  }
}
