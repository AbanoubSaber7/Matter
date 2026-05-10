# 🚀 كيفية تشغيل التطبيق بأمان

## ⚡ البدء السريع (دقيقتان)

```bash
# 1. احصل على Gemini API Key من:
#    https://aistudio.google.com/app/apikey

# 2. شغّل التطبيق (استبدل YOUR_KEY بالمفتاح الفعلي)
flutter run --dart-define=GEMINI_API_KEY='AIzaSyABC...'

# 3. اكتب رسالة في الدردشة
# 4. استقبل الرد من الذكاء الاصطناعي ✅
```

---

## 📝 طريقة .env (الموصى به)

### أولاً: أنشئ ملف `.env`

في جذر المشروع (`D:\Downloads\Matter-main\Matter-main\`):

**الملف:** `.env`
**المحتوى:**
```
GEMINI_API_KEY=AIzaSyABC... (ضع مفتاحك هنا)
```

**ملاحظة مهمة:** هذا الملف يجب أن يكون **في `.gitignore`** ✅ (فعلاً موجود)

### ثانياً: أضف flutter_dotenv إلى pubspec.yaml

```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

### ثالثاً: حمّل المتغيرات في main.dart

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}
```

### رابعاً: شغّل بشكل طبيعي

```bash
flutter run
```

---

## 🔒 طريقة Firebase Remote Config (الأكثر أماناً)

### أولاً: فعّل Firebase Remote Config

1. اذهب إلى Firebase Console
2. اختر المشروع
3. Remote Config → Create New Config
4. أضف معامل جديد:
   - **Key:** `gemini_api_key`
   - **Value:** `AIzaSyABC...`

### ثانياً: حدّث الكود

```dart
// في gemini_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

static Future<String> get _apiKey async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getString('gemini_api_key');
}
```

### الفوائد:
- ✅ آمن جداً (المفتاح في السحابة فقط)
- ✅ يمكن التحديث بدون بناء جديد
- ✅ يمكن التبديل الفوري
- ✅ لا يوجد في الكود

---

## 🧪 اختبر الآن

### 1. افتح Terminal

```bash
cd D:\Downloads\Matter-main\Matter-main
```

### 2. احصل على مفتاح جديد

اذهب إلى: https://aistudio.google.com/app/apikey
انسخ المفتاح

### 3. شغّل التطبيق

**الخيار 1 (المباشر):**
```bash
flutter run --dart-define=GEMINI_API_KEY='AIzaSy_YOUR_KEY_HERE'
```

**الخيار 2 (مع .env):**

أنشئ `.env`:
```bash
# Windows
echo GEMINI_API_KEY=AIzaSy_YOUR_KEY > .env

# Mac/Linux
echo "GEMINI_API_KEY=AIzaSy_YOUR_KEY" > .env
```

ثم:
```bash
flutter run
```

### 4. اختبر الميزات

- ✅ اكتب: "مرحباً"
- ✅ يجب أن تستقبل رد
- ✅ لا توجد أخطاء حمراء
- ✅ التطبيق يعمل بسلاسة

---

## 🛠️ استكشاف الأخطاء

| المشكلة | الحل |
|--------|------|
| `GEMINI_API_KEY not configured` | استخدم `--dart-define` أو أنشئ `.env` |
| `Invalid API Key` | تأكد من نسخ المفتاح بشكل صحيح |
| `Quota exceeded` | احصل على مفتاح جديد من Google |
| `Connection timeout` | تحقق من الإنترنت |
| `API not enabled` | فعّل Gemini API من Google Cloud Console |

---

## 🔐 نصائح الأمان

### قبل الترفع (Deployment)

```bash
# ✅ تأكد أن .env في .gitignore
cat .gitignore | grep GEMINI_API_KEY

# ✅ تأكد أن لا توجد مفاتيح في الكود
grep -r "AIzaSy" lib/

# ✅ استخدم Firebase Remote Config أو Secrets Manager
```

### في الإنتاج

- ❌ لا تضع المفتاح في الكود
- ✅ استخدم Firebase Remote Config
- ✅ أو استخدم Backend API
- ✅ أو استخدم Android Keystore / iOS Keychain

---

## 📊 المراحل

```
المرحلة 1: التطوير المحلي
├─ استخدم: flutter run --dart-define=GEMINI_API_KEY='...'
└─ أو: .env + flutter_dotenv

المرحلة 2: الاختبار
├─ استخدم: ملف .env
└─ تأكد من عدم رفعه على Git

المرحلة 3: الإنتاج
├─ استخدم: Firebase Remote Config
├─ أو: Backend API
└─ أو: Native Keystore
```

---

## 📚 أوامر مفيدة

```bash
# تنظيف البناء السابق
flutter clean

# الحصول على الحزم
flutter pub get

# تشغيل مع تفاصيل
flutter run -v --dart-define=GEMINI_API_KEY='...'

# تشغيل بدون reload سريع
flutter run --no-fast-start

# تشغيل على جهاز محدد
flutter run -d <device-id>
```

---

## ✅ قائمة التحقق

- [ ] تحصل على مفتاح من Google AI Studio
- [ ] تشغّل التطبيق باستخدام `--dart-define`
- [ ] تختبر الدردشة والردود
- [ ] لا توجد أخطاء API
- [ ] تضيف المفتاح إلى .env (بدون .gitignore commit)
- [ ] تتأكد أن .env في .gitignore
- [ ] تختبر على جهاز فعلي

---

## 🆘 الدعم

إذا استمرت المشاكل:

1. **فحص السجلات:**
   ```bash
   flutter run -v
   ```

2. **حذف الـ Build القديم:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **استخدام مفتاح جديد:**
   - اذهب إلى Google AI Studio
   - أنشئ مفتاح جديد
   - حاول مجدداً

4. **راجع المستندات:**
   - [FIXING_API_KEY_ISSUE.md](FIXING_API_KEY_ISSUE.md)
   - [GET_GEMINI_API_KEY.md](GET_GEMINI_API_KEY.md)
