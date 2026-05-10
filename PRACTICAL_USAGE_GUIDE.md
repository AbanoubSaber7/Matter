# 🚀 دليل الاستخدام العملي

## كيفية دمج نظام الكشف في مشروعك

### الخطوة 1: الاستيراد

```dart
import 'package:you_matter_app/models/risk_assessment.dart';
import 'package:you_matter_app/services/risk_engine.dart';
```

### الخطوة 2: الاستخدام الأساسي

```dart
// تحليل نص بسيط
RiskAssessment assessment = RiskEngine.analyzeText("أنا حزين");

// الوصول إلى النتائج
print('المستوى: ${assessment.level}');        // MEDIUM
print('الثقة: ${assessment.confidence}%');    // 68.5%
print('السبب: ${assessment.reason}');         // ⚡ ضغط نفسي
print('الكلمات: ${assessment.detectedKeywords}'); // [حزين]
```

---

## 📱 تطبيق عملي كامل في الشاشة

```dart
import 'package:flutter/material.dart';
import '../models/risk_assessment.dart';
import '../services/risk_engine.dart';

class ChatExampleScreen extends StatefulWidget {
  @override
  State<ChatExampleScreen> createState() => _ChatExampleScreenState();
}

class _ChatExampleScreenState extends State<ChatExampleScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  void _analyzeAndSend() {
    String userText = _controller.text.trim();
    if (userText.isEmpty) return;

    // تحليل المخاطر
    RiskAssessment assessment = RiskEngine.analyzeText(userText);

    // إضافة الرسالة
    setState(() {
      messages.add("أنت: $userText");
    });

    // معالجة حسب المستوى
    switch (assessment.level) {
      case RiskLevel.critical:
        _showCriticalDialog(assessment);
        break;
      case RiskLevel.high:
        _showHighDialog(assessment);
        break;
      case RiskLevel.medium:
        _showMediumSnackBar(assessment);
        break;
      case RiskLevel.low:
        // لا نحتاج لتنبيه
        break;
    }

    _controller.clear();
  }

  void _showCriticalDialog(RiskAssessment assessment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(assessment.reason, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("الكلمات المكتشفة: ${assessment.detectedKeywords.join(', ')}"),
            SizedBox(height: 16),
            Text("التوصيات:"),
            ...assessment.recommendations.map((rec) => Text("• $rec")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("حسناً"),
          ),
        ],
      ),
    );
  }

  void _showHighDialog(RiskAssessment assessment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(assessment.reason, style: TextStyle(color: Colors.orange)),
        content: Text("الثقة: ${assessment.confidence.toStringAsFixed(1)}%"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("حسناً"),
          ),
        ],
      ),
    );
  }

  void _showMediumSnackBar(RiskAssessment assessment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(assessment.reason),
        backgroundColor: Colors.amber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("مثال الكشف")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(title: Text(messages[index])),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: "اكتب رسالة..."),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _analyzeAndSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔍 أمثلة متقدمة

### مثال 1: حفظ البيانات في Firestore

```dart
Future<void> _saveAssessment(RiskAssessment assessment) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('riskAssessments');

    await collection.add(assessment.toMap());
    print('✅ تم حفظ التقييم');
  } catch (e) {
    print('❌ خطأ: $e');
  }
}
```

### مثال 2: إرسال تنبيهات جماعية

```dart
Future<void> _notifyGuardians(RiskAssessment assessment) async {
  if (assessment.level != RiskLevel.critical) return;

  final contacts = await _getGuardianPhones();
  final sms = "تنبيه: ${assessment.reason}";

  for (var phone in contacts) {
    await Telephony.instance.sendSms(to: phone, message: sms);
  }
}
```

### مثال 3: إنشاء تقارير يومية

```dart
Future<List<RiskAssessment>> _getDailyReport() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);

  final docs = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('riskAssessments')
      .where('timestamp', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
      .get();

  return docs.docs
      .map((doc) => RiskAssessment.fromMap(doc.data()))
      .toList();
}
```

---

## 🎨 تخصيص الألوان والنصوص

### تغيير الألوان

```dart
// قبل: في chat_screen.dart
color: const Color(0xFFFF6B6B), // أحمر

// بعد: استخدم ألوان مخصصة
color: const Color(0xFF...) // لونك المفضل
```

### تخصيص الرسائل

```dart
// في risk_engine.dart
static String _generateReason(RiskLevel level, List<String> keywords) {
  switch (level) {
    case RiskLevel.critical:
      return 'رسالتك المخصصة هنا'; // غيّر هنا
    // ...
  }
}
```

### تخصيص التوصيات

```dart
// في risk_engine.dart
case RiskLevel.high:
  return [
    'توصيتك الأولى', // غيّر هنا
    'توصيتك الثانية',
    // ...
  ];
```

---

## 🔧 إضافة كلمات مفتاحية جديدة

### إضافة كلمة حرجة جديدة

```dart
// في risk_engine.dart
static const List<String> _criticalKeywords = [
  'انتحار', 'suicide',
  // أضف كلماتك الجديدة هنا:
  'كلمتك الجديدة 1',
  'كلمتك الجديدة 2',
];
```

### إضافة كلمة موجبة جديدة

```dart
// في risk_engine.dart
static const List<String> _positiveKeywords = [
  'أفضل', 'better',
  // أضف كلماتك الجديدة هنا:
  'كلمتك الموجبة 1',
  'كلمتك الموجبة 2',
];
```

---

## 🧠 فهم النتائج

### رسالة مثال: "أنا يائس ولا أحد يفهمني"

```
التحليل:
├─ كلمات مكتشفة: [يائس، لا أحد يفهمني]
├─ النقاط:
│  ├─ يائس: +30 (عالي)
│  ├─ لا أحد يفهمني: +30 (عالي)
│  └─ إجمالي: 60
├─ مستوى: HIGH (≥35)
├─ الثقة: 82% (كلمات متعددة + درجة عالية)
└─ السبب: "⚠️ تم كشف مؤشرات خطر عالية"

الإجراء:
└─ عرض Dialog عالي الأولوية
```

### رسالة مثال: "أنا متعب لكنني بتحسن"

```
التحليل:
├─ كلمات مكتشفة: [متعب، بتحسن]
├─ النقاط:
│  ├─ متعب: +15 (متوسط)
│  ├─ بتحسن: -20 (موجب)
│  └─ إجمالي: -5 → 0 (لا نستخدم الأرقام السالبة)
├─ مستوى: LOW
├─ الثقة: 55% (كلمات قليلة)
└─ السبب: "✅ رسالة عادية"

الإجراء:
└─ لا توجد تنبيهات
```

---

## ⚙️ ضبط دقة الكشف

### إذا كان النظام حساساً جداً (False Positives)

```dart
// زيادة درجات الخطر
static const int _criticalThreshold = 60; // كان 50

// أو إضافة كلمات موجبة أكثر
static const List<String> _positiveKeywords = [
  'أفضل', 'better',
  'آمل', 'hope',
  'سأحاول', 'will try',
  // أضف كلمات موجبة أكثر
];
```

### إذا كان النظام حساساً قليل (False Negatives)

```dart
// تقليل درجات الخطر
static const int _criticalThreshold = 40; // كان 50

// أو إضافة كلمات خطيرة أكثر
static const List<String> _criticalKeywords = [
  'انتحار', 'suicide',
  // أضف كلمات خطيرة أخرى
];
```

---

## 🐛 استكشاف الأخطاء الشائعة

### المشكلة: الرسالة لا تُحلل

```dart
// ❌ خطأ
String text = null;
final assessment = RiskEngine.analyzeText(text); // NullPointerException

// ✅ صحيح
String text = "أنا حزين";
final assessment = RiskEngine.analyzeText(text);
```

### المشكلة: الكلمة لا تُكتشف

```dart
// ❌ قد تكون الكلمة بنفس الحالة (case)
if (text.contains('Suicide')) // الحرف الأول كبير
  // لن تعمل

// ✅ استخدم toLowerCase() أولاً
String lowerText = text.toLowerCase();
if (lowerText.contains('suicide'))
  // سيعمل
```

### المشكلة: الثقة منخفضة جداً

```dart
// قد يكون عدد الكلمات قليل جداً
// أضف المزيد من الكلمات المفتاحية
// أو قلل الحد الأدنى للثقة
double confidence = 30; // بدلاً من 50
```

---

## 📚 موارد إضافية

### ملفات التوثيق ذات الصلة

```
├─ RISK_DETECTION_SYSTEM.md       # شرح شامل للنظام
├─ RISK_DETECTION_DIAGRAMS.md     # رسوم بيانية
├─ RISK_DETECTION_IMPLEMENTATION_SUMMARY.md # الملخص
├─ TESTING_GUIDE.md               # دليل الاختبار
└─ MISSING_FEATURES_SUMMARY_AR.md # الميزات الناقصة
```

### الملفات الرئيسية

```
├─ lib/models/risk_assessment.dart      # النموذج
├─ lib/services/risk_engine.dart        # المحرك
├─ lib/screens/chat_screen.dart         # الاستخدام
└─ test/risk_detection_test.dart        # الاختبارات
```

---

## ✨ نصائح وحيل

### نصيحة 1: التخزين المؤقت

```dart
// بدلاً من التحليل في كل مرة
final cache = {};

RiskAssessment getAssessment(String text) {
  if (cache.containsKey(text)) {
    return cache[text];
  }
  final assessment = RiskEngine.analyzeText(text);
  cache[text] = assessment;
  return assessment;
}
```

### نصيحة 2: المعالجة المتوازية

```dart
// تحليل عدة رسائل في الوقت نفسه
Future<List<RiskAssessment>> analyzeMultiple(List<String> messages) async {
  return Future.wait(
    messages.map((msg) async => RiskEngine.analyzeText(msg))
  );
}
```

### نصيحة 3: التسجيل (Logging)

```dart
// سجل كل تحليل للتصحيح
void _logAssessment(RiskAssessment assessment) {
  print('📊 التحليل:');
  print('   المستوى: ${assessment.level}');
  print('   الثقة: ${assessment.confidence}%');
  print('   الكلمات: ${assessment.detectedKeywords}');
}
```

---

## 🎯 أفضل الممارسات

1. **دائماً تحقق من المستوى قبل الإجراء**
   ```dart
   if (assessment.level == RiskLevel.critical) {
     // اتخذ إجراء فوري
   }
   ```

2. **احفظ جميع التحليلات للمراجعة**
   ```dart
   await _saveAssessment(assessment);
   ```

3. **أظهر رسائل واضحة للمستخدم**
   ```dart
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(content: Text(assessment.reason))
   );
   ```

4. **لا تعتمد على الكشف الآلي وحده**
   - جميع التحليلات يجب أن تُراجع من قبل متخصصين

5. **تحديث الكلمات المفتاحية بانتظام**
   - أضف كلمات جديدة بناءً على تجربتك

---

## 🚨 تنبيهات أمان

⚠️ **تحذير:** لا تستخدم هذا النظام وحده
- يجب أن يكون هناك إشراف متخصص
- جميع التنبيهات يجب أن تُراجع يدوياً
- الاعتماد على الذكاء الاصطناعي وحده غير كافٍ

---

**تم إنشاء هذا الدليل:** يونيو 2026
**النسخة:** 1.0
**الحالة:** ✅ جاهز

