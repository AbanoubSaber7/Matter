# YouMatter App 💚
**Mental Health Support Application with AI Companion**

---

## ⚠️ مهم: إعداد Gemini API Key

**قبل تشغيل التطبيق، يجب إعداد مفتاح Gemini API:**

```bash
flutter run --dart-define=GEMINI_API_KEY='YOUR_KEY_HERE'
```

📖 **شرح مفصّل:** اقرأ [SETUP_API_KEY.md](SETUP_API_KEY.md)

---

## 🚀 البدء السريع

### المتطلبات
- Flutter 3.0+
- Dart 2.17+
- Android SDK / iOS SDK
- Firebase Account
- Gemini API Key

### التثبيت

```bash
# 1. استنسخ المشروع
git clone <repository-url>
cd Matter-main

# 2. احصل على الحزم
flutter pub get

# 3. احصل على مفتاح Gemini من:
# https://aistudio.google.com/app/apikey

# 4. شغّل التطبيق
flutter run --dart-define=GEMINI_API_KEY='YOUR_KEY'
```

---

## 📋 الميزات الرئيسية

### ✅ تم إنجازه
- 🔐 نظام مصادقة آمن (Firebase Auth)
- 💬 دردشة مع Gemini AI
- 🚨 نظام كشف المخاطر (60+ كلمة مفتاحية)
- 📞 إدارة جهات الطوارئ الموثوقة
- 📚 مكتبة الموارد والخطوط الساخنة
- 🎨 تصميم Material 3
- 🌍 دعم اللغات (العربية والإنجليزية)

### ❌ قيد التطوير
- 💾 حفظ سجل الدردشة في Database
- 📊 تتبع الحالة المزاجية
- 🧘 تمارين التنفس والتأمل
- 🔒 تحسينات الأمان والخصوصية

---

## 📁 هيكل المشروع

```
lib/
├── main.dart                          # نقطة البداية
├── screens/                           # جميع الشاشات
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── chat_screen.dart              # الشاشة الرئيسية
│   ├── emergency_contacts_screen.dart
│   └── profile_screen.dart
├── services/                          # خدمات التطبيق
│   ├── auth_service.dart             # Firebase Auth
│   ├── firestore_service.dart        # Firestore Database
│   ├── gemini_service.dart           # Gemini AI
│   └── risk_engine.dart              # كشف المخاطر
├── models/                            # نماذج البيانات
│   ├── message.dart
│   └── risk_assessment.dart
├── providers/                         # State Management
│   ├── app_mode_provider.dart
│   └── user_provider.dart
└── config/                            # الإعدادات
    └── api_keys.dart                 # API Keys آمنة
```

---

## 🔐 الأمان

### إدارة المفاتيح
- ❌ لا تكتب API Keys في الكود
- ✅ استخدم `--dart-define` أو Firebase Remote Config
- ✅ أضف `api_keys.dart` إلى `.gitignore`

### Firebase Security Rules
```
// تجاهل ملفات حساسة
.env
.env.local
lib/config/api_keys.dart
google-services.json
```

---

## 🧪 الاختبار

```bash
# اختبر مع المفتاح
flutter run --dart-define=GEMINI_API_KEY='test_key'

# اختبر بدون Live reload
flutter run --no-fast-start

# اختبر على جهاز محدد
flutter run -d <device-id>
```

---

## 📱 الأجهزة المدعومة
- ✅ Android 5.0+
- ✅ iOS 11.0+
- ⚠️ Web (قيد الاختبار)

---

## 📚 الموارد والتوثيق

- [RISK_DETECTION_SYSTEM.md](RISK_DETECTION_SYSTEM.md) - شرح نظام كشف المخاطر
- [TESTING_GUIDE.md](TESTING_GUIDE.md) - دليل الاختبار الشامل
- [PRACTICAL_USAGE_GUIDE.md](PRACTICAL_USAGE_GUIDE.md) - دليل الاستخدام
- [SETUP_API_KEY.md](SETUP_API_KEY.md) - إعداد API Key **مهم جداً**

---

## 🤝 المساهمة

يرجى اتباع المعايير التالية عند المساهمة:
1. إنشاء branch جديد: `git checkout -b feature/feature-name`
2. Commit التغييرات: `git commit -m 'Add feature'`
3. Push إلى Branch: `git push origin feature/feature-name`
4. فتح Pull Request

---

## 📞 الدعم

للمشاكل والأسئلة:
- 📧 البريد الإلكتروني: support@youmatter.app
- 🐛 Report Bugs: GitHub Issues

---

## 📄 الترخيص

هذا المشروع مرخص تحت MIT License - انظر ملف [LICENSE](LICENSE) للتفاصيل.
