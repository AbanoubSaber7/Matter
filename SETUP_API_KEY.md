# 🔐 إعداد Gemini API Key بشكل آمن

## ⚠️ المشكلة
مفتاح API السابق تم تسريبه ولا يعمل بعد الآن.

---

## ✅ الحل: 4 خطوات

### 1️⃣ الحصول على مفتاح API جديد

1. اذهب إلى: https://aistudio.google.com/app/apikey
2. اضغط **"Create API Key"**
3. اختر المشروع الخاص بك
4. انسخ المفتاح الجديد

```
المفتاح يبدو هكذا: AIzaSy... (طويل جداً)
```

---

### 2️⃣ تشغيل التطبيق بالمفتاح الجديد

**الطريقة الأولى (الأسهل للاختبار):**

```bash
flutter run --dart-define=GEMINI_API_KEY='YOUR_NEW_KEY_HERE'
```

مثال حقيقي:
```bash
flutter run --dart-define=GEMINI_API_KEY='AIzaSyAFYASz7_mGNVb63Y5UQiZDgeZNZgVbW5g'
```

**الطريقة الثانية (الأكثر أماناً - باستخدام ملف):**

إنشاء ملف `.env` في جذر المشروع:

```env
GEMINI_API_KEY=AIzaSyAFYASz7_mGNVb63Y5UQiZDgeZNZgVbW5g
```

ثم استخدام package: `flutter_dotenv`

---

### 3️⃣ الطريقة الأفضل: Firebase Remote Config

لتطبيق إنتاجي (production)، استخدم Firebase Remote Config:

```dart
// مثال الكود:
Future<String> getGeminiKey() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getString('gemini_api_key');
}
```

**المميزات:**
- ✅ آمن جداً
- ✅ يمكن تحديثه بدون تطبيق جديد
- ✅ يمكن تفعيل/تعطيل المفتاح فوراً

---

### 4️⃣ عدم نشر المفتاح على Git ❌

تأكد من إضافة هذه الملفات إلى `.gitignore`:

```
.env
.env.local
lib/config/secret_keys.dart
google-services.json
```

---

## 📝 ملف `.gitignore` محدّث

```
# تجاهل ملفات الإعدادات الحساسة
.env
.env.*
lib/config/secret_keys.dart
lib/config/api_keys.dart

# Firebase
google-services.json
GoogleService-Info.plist

# Build artifacts
build/
.dart_tool/
.flutter-plugins
.packages
```

---

## 🧪 اختبر الآن

بعد إضافة المفتاح الجديد:

```bash
# 1. نظّف البناء السابق
flutter clean

# 2. احصل على الحزم
flutter pub get

# 3. شغّل مع المفتاح الجديد
flutter run --dart-define=GEMINI_API_KEY='YOUR_KEY'
```

---

## ✅ كيف تعرف أن كل شيء صحيح؟

1. ✅ التطبيق يبدأ بدون أخطاء
2. ✅ تستطيع الكتابة في الدردشة
3. ✅ تستقبل ردود من Gemini مباشرة
4. ✅ لا توجد رسالة "API key leaked"

---

## 🆘 إذا حدثت مشكلة

**خطأ: "Invalid API Key"**
- تأكد أن المفتاح صحيح (انسخه مرة أخرى)
- تأكد من تفعيل Gemini API في Google Cloud Console

**خطأ: "Quota exceeded"**
- المفتاح يستخدم في أماكن أخرى
- احصل على مفتاح جديد

**خطأ: "API not found"**
- المشروع لا يملك صلاحيات Gemini
- اذهب إلى Google Cloud Console وفعّل API

---

## 📚 مراجع مفيدة

- 🔗 [Google AI Studio](https://aistudio.google.com/app/apikey)
- 🔗 [Gemini API Docs](https://ai.google.dev/tutorials/dart_quickstart)
- 🔗 [Firebase Remote Config](https://firebase.google.com/docs/remote-config)
