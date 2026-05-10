# 🧪 دليل تشغيل الاختبارات

## الخطوات السريعة

### 1. تشغيل جميع الاختبارات

```bash
flutter test
```

### 2. تشغيل اختبارات كشف المخاطر فقط

```bash
flutter test test/risk_detection_test.dart
```

### 3. تشغيل مجموعة اختبارات محددة

```bash
# Critical Risk Tests فقط
flutter test test/risk_detection_test.dart -n "Critical Risk Tests"

# High Risk Tests فقط
flutter test test/risk_detection_test.dart -n "High Risk Tests"

# Low Risk Tests فقط
flutter test test/risk_detection_test.dart -n "Low Risk Tests"
```

### 4. تشغيل مع تفاصيل

```bash
flutter test test/risk_detection_test.dart -v
```

### 5. تشغيل مع تقرير التغطية

```bash
flutter test --coverage
```

---

## 📊 مجموعات الاختبار

### مجموعة 1: Critical Risk Tests
```bash
flutter test test/risk_detection_test.dart -n "Critical Risk Tests"
```
**ماذا يختبر:**
- ✅ اكتشاف كلمات الانتحار
- ✅ اكتشاف كلمات إيذاء النفس
- ✅ اكتشاف كلمات متعددة خطيرة
- ✅ اللغة الإنجليزية
- ✅ الجرعات الزائدة

**النتيجة المتوقعة:** كل الاختبارات يجب أن تكون CRITICAL

---

### مجموعة 2: High Risk Tests
```bash
flutter test test/risk_detection_test.dart -n "High Risk Tests"
```
**ماذا يختبر:**
- ✅ اليأس والاستسلام
- ✅ أفكار إيذاء النفس
- ✅ الشعور ببلا قيمة
- ✅ الوحدة والعزلة

**النتيجة المتوقعة:** كل الاختبارات يجب أن تكون HIGH

---

### مجموعة 3: Medium Risk Tests
```bash
flutter test test/risk_detection_test.dart -n "Medium Risk Tests"
```
**ماذا يختبر:**
- ✅ القلق والقلق الشديد
- ✅ الإرهاق والتعب
- ✅ الحزن
- ✅ البكاء والدموع

**النتيجة المتوقعة:** كل الاختبارات يجب أن تكون MEDIUM

---

### مجموعة 4: Low Risk Tests
```bash
flutter test test/risk_detection_test.dart -n "Low Risk Tests"
```
**ماذا يختبر:**
- ✅ رسائل عادية
- ✅ رسائل إيجابية
- ✅ رسائل متفائلة
- ✅ رسائل فارغة

**النتيجة المتوقعة:** كل الاختبارات يجب أن تكون LOW

---

### مجموعة 5: Balanced Message Tests
```bash
flutter test test/risk_detection_test.dart -n "Balanced Message Tests"
```
**ماذا يختبر:**
- ✅ التوازن بين الكلمات السلبية والإيجابية
- ✅ الكلمات المختلطة

**النتيجة المتوقعة:** يجب أن تقلل الكلمات الإيجابية من درجة الخطر

---

### مجموعة 6: Confidence Score Tests
```bash
flutter test test/risk_detection_test.dart -n "Confidence Score Tests"
```
**ماذا يختبر:**
- ✅ ثقة عالية مع عدة كلمات
- ✅ ثقة منخفضة مع كلمة واحدة
- ✅ نطاق الثقة (0-100%)

**النتيجة المتوقعة:** يجب أن تكون جميع القيم بين 0-100

---

### مجموعة 7: Detected Keywords Tests
```bash
flutter test test/risk_detection_test.dart -n "Detected Keywords Tests"
```
**ماذا يختبر:**
- ✅ اكتشاف واستخراج الكلمات
- ✅ عدم التكرار
- ✅ حساسية الأحرف

**النتيجة المتوقعة:** يجب أن تكون الكلمات فريدة وصحيحة

---

### مجموعة 8: Recommendations Tests
```bash
flutter test test/risk_detection_test.dart -n "Recommendations Tests"
```
**ماذا يختبر:**
- ✅ وجود توصيات لكل مستوى
- ✅ عدم الفراغ

**النتيجة المتوقعة:** يجب أن تكون هناك توصيات لكل مستوى

---

### مجموعة 9: RiskAssessment Model Tests
```bash
flutter test test/risk_detection_test.dart -n "RiskAssessment Model Tests"
```
**ماذا يختبر:**
- ✅ تحويل إلى Map
- ✅ إنشاء من Map

**النتيجة المتوقعة:** يجب أن تكون البيانات محفوظة ومسترجعة بشكل صحيح

---

### مجموعة 10: Performance Tests
```bash
flutter test test/risk_detection_test.dart -n "Performance Tests"
```
**ماذا يختبر:**
- ✅ سرعة التحليل (يجب أن يكون أقل من 100ms)
- ✅ معالجة الرسائل الطويلة

**النتيجة المتوقعة:** يجب أن يكون التحليل سريع جداً

---

### مجموعة 11: Edge Cases Tests
```bash
flutter test test/risk_detection_test.dart -n "Edge Cases Tests"
```
**ماذا يختبر:**
- ✅ الأحرف الخاصة
- ✅ لغات مختلطة
- ✅ أحرف مكررة
- ✅ مسافات إضافية

**النتيجة المتوقعة:** يجب أن يتعامل مع جميع الحالات بدون أخطاء

---

## 🎯 سيناريوهات الاختبار العملية

### السيناريو 1: المستخدم في أزمة حقيقية

```dart
final assessment = RiskEngine.analyzeText(
  "أنا لا أستطيع تحمل هذا، أريد أن أنهي حياتي الآن"
);

// النتيجة المتوقعة:
expect(assessment.level, RiskLevel.critical);
expect(assessment.confidence, greaterThan(90));
expect(assessment.detectedKeywords.isNotEmpty, true);
expect(assessment.recommendations.isNotEmpty, true);
```

### السيناريو 2: المستخدم بحاجة للدعم

```dart
final assessment = RiskEngine.analyzeText(
  "أشعر بحزن وقلق لكنني أأمل أن تتحسن الأمور قريباً"
);

// النتيجة المتوقعة:
expect(assessment.level, RiskLevel.medium);
expect(assessment.confidence, isWithin(50, 80));
```

### السيناريو 3: رسالة عادية

```dart
final assessment = RiskEngine.analyzeText(
  "كيف حالك؟ أنا بخير اليوم"
);

// النتيجة المتوقعة:
expect(assessment.level, RiskLevel.low);
expect(assessment.confidence, greaterThan(90));
```

---

## 🐛 استكشاف الأخطاء

### الاختبار يفشل؟

#### 1. تحقق من الاستيرادات
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:you_matter_app/models/risk_assessment.dart';
import 'package:you_matter_app/services/risk_engine.dart';
```

#### 2. تأكد من أن التطبيق مُجمّع
```bash
flutter pub get
flutter build apk  # أو ios
```

#### 3. شغّل الاختبار بـ verbose
```bash
flutter test test/risk_detection_test.dart -v
```

#### 4. تحقق من الأخطاء الشائعة
```
❌ NoSuchMethodError → تأكد من وجود الدوال
❌ RangeError → تأكد من نطاق القيم
❌ FormatException → تأكد من صيغة البيانات
```

---

## 📈 قراءة النتائج

### نتيجة ناجحة ✅

```
============================================
Run 50/50 tests ✅

All tests passed! 🎉
============================================
```

### نتيجة فشل ❌

```
FAILED: test/risk_detection_test.dart
Expected: RiskLevel.critical
Actual: RiskLevel.high

Check the keywords or scoring logic
```

---

## 🎓 أمثلة الاختبار

### مثال 1: اختبار كلمة حرجة

```dart
test('Should detect suicide keywords', () {
  final assessment = RiskEngine.analyzeText('أنا أريد أن أنهي حياتي');
  expect(assessment.level, equals(RiskLevel.critical));
  expect(assessment.confidence, greaterThanOrEqualTo(50));
});
```

### مثال 2: اختبار التوازن

```dart
test('Should reduce risk with positive keywords', () {
  final assessment1 = RiskEngine.analyzeText('أنا حزين');
  final assessment2 = RiskEngine.analyzeText('كنت حزيناً لكنني بتحسن الآن');
  
  expect(assessment2.level.index, lessThanOrEqualTo(assessment1.level.index));
});
```

### مثال 3: اختبار الأداء

```dart
test('Should analyze message quickly', () {
  final stopwatch = Stopwatch()..start();
  RiskEngine.analyzeText('أنا أشعر بقلق وحزن');
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(100));
});
```

---

## 📊 تقرير التغطية

### إنشاء تقرير

```bash
# على Windows
flutter test --coverage
lcov --list coverage/lcov.info

# أو
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
start coverage/html/index.html
```

### المتوقع

```
coverage: 85%+
المكتشفة من المحرك: 90%
الشاشات: 70%
الموارد: 95%
```

---

## ✅ قائمة الفحص

قبل التسليم:

- [ ] جميع الاختبارات تمر بنجاح ✅
- [ ] لا توجد رسائل تحذير 🟡
- [ ] التغطية أكثر من 80% 📊
- [ ] الأداء أقل من 100ms ⚡
- [ ] الحالات الحدية مُغطاة 🛡️
- [ ] التوثيق واضح 📚
- [ ] الكود نظيف 🧹

---

**تم إنشاء هذا الدليل:** يونيو 2026
**النسخة:** 1.0
**الحالة:** ✅ جاهز للاستخدام

