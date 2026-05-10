# 🆘 حل مشكلة "API key was reported as leaked"

## المشكلة
```
خطأ: Your API key was reported as leaked. Please use another API key.
```

---

## ✅ الحل الفوري (3 خطوات)

### خطوة 1: احصل على مفتاح جديد
1. اذهب إلى: https://aistudio.google.com/app/apikey
2. اضغط على "Create API Key"
3. اختر المشروع
4. انسخ المفتاح الجديد (يبدأ بـ `AIzaSy...`)

### خطوة 2: شغّل التطبيق مع المفتاح الجديد

```bash
# استبدل YOUR_KEY بالمفتاح الفعلي
flutter run --dart-define=GEMINI_API_KEY='AIzaSy_YOUR_KEY_HERE'
```

### خطوة 3: اختبر الدردشة
- افتح التطبيق
- اكتب رسالة
- تأكد أنك تستقبل ردود

---

## 🔧 الإعداد الدائم (الأفضل)

### الخطوة 1: إنشاء ملف `.env`

في جذر المشروع، أنشئ ملف اسمه `.env`:

```bash
# Windows/Mac/Linux
echo GEMINI_API_KEY=AIzaSy_YOUR_KEY > .env
```

أو افتح محرر نصوص وأنشئ الملف يدويّاً:

**المحتوى:**
```
GEMINI_API_KEY=AIzaSy_YOUR_KEY_HERE
```

### الخطوة 2: حدّث `pubspec.yaml`

أضف الحزمة:

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
  google_generative_ai: ^0.4.7
```

### الخطوة 3: حدّث `lib/main.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}
```

### الخطوة 4: حدّث `lib/services/gemini_service.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

static String get _apiKey {
  return dotenv.env['GEMINI_API_KEY'] ?? '';
}
```

---

## 🎯 خيارات التشغيل

### ✅ الأسهل (للاختبار السريع)
```bash
flutter run --dart-define=GEMINI_API_KEY='AIzaSy...'
```

### ✅ الأفضل (للتطوير المستمر)
```bash
# أولاً: أنشئ .env
echo GEMINI_API_KEY=AIzaSy... > .env

# ثم: استخدم flutter_dotenv
flutter run
```

### ✅ الأكثر أماناً (للإنتاج)
استخدم Firebase Remote Config:
```dart
// في gemini_service.dart
final remoteConfig = FirebaseRemoteConfig.instance;
final key = remoteConfig.getString('gemini_api_key');
```

---

## ✅ تحقق من النجاح

```bash
✅ التطبيق يبدأ بدون أخطاء
✅ تستطيع الكتابة في الدردشة
✅ تستقبل ردود من Gemini
✅ لا توجد رسالة خطأ حمراء
```

---

## 🆘 استكشاف الأخطاء

| الخطأ | السبب | الحل |
|------|------|------|
| Invalid API Key | المفتاح خاطئ | انسخ المفتاح مرة أخرى من Google |
| Quota exceeded | استخدام شديد | احصل على مفتاح جديد |
| API not enabled | لم تفعّل Gemini API | فعّل API من Google Cloud Console |
| Connection timeout | لا توجد إنترنت | تحقق من الاتصال |

---

## 🔐 نصائح الأمان

❌ **لا تفعل:**
```dart
static const String _apiKey = 'AIzaSy...'; // ❌ خطير جداً!
```

✅ **افعل:**
```dart
// استخدم environment variables
static String get _apiKey => const String.fromEnvironment('GEMINI_API_KEY');
```

---

## 📞 الدعم

إذا استمرت المشكلة:
1. تحقق من أن المفتاح نسخته بشكل صحيح
2. جرّب مفتاح جديد من Google
3. تأكد من تفعيل Gemini API في Google Cloud Console
4. راجع السجلات: `flutter run -v`
