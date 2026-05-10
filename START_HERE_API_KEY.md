# 🆘 خطأ: API Key مسرب - ابدأ من هنا!

## ⚠️ المشكلة
```
Your API key was reported as leaked. 
Please use another API key.
```

---

## ✅ الحل (3 دقائق فقط)

### الخطوة 1️⃣: احصل على مفتاح جديد (دقيقة واحدة)

1. افتح المتصفح
2. اذهب إلى: https://aistudio.google.com/app/apikey
3. اضغط الزر الأزرق: **"Create API Key"**
4. اختر المشروع ثم **"Create"**
5. **انسخ المفتاح** (أيقونة النسخ)

```
يبدو هكذا: AIzaSyABC...xyz
```

---

### الخطوة 2️⃣: شغّل التطبيق بالمفتاح الجديد (دقيقتان)

افتح Terminal وشغّل:

```bash
cd D:\Downloads\Matter-main\Matter-main

flutter run --dart-define=GEMINI_API_KEY='AIzaSyABC...xyz'
```

**استبدل `AIzaSyABC...xyz` بالمفتاح الذي نسخته من Google**

---

### الخطوة 3️⃣: اختبر (دقيقة واحدة)

1. افتح التطبيق
2. اكتب أي رسالة
3. إذا رد عليك الذكاء الاصطناعي ✅ تم!

---

## 🎯 يجب أن ترى

```
✅ التطبيق يبدأ بدون أخطاء
✅ تستطيع الكتابة
✅ تستقبل ردود من AI
✅ لا توجد رسالة خطأ حمراء
```

---

## 📚 للمزيد من التفاصيل

- 📖 [شرح مفصّل لنيل المفتاح](GET_GEMINI_API_KEY.md)
- 🚀 [كيفية تشغيل التطبيق بأمان](RUNNING_THE_APP.md)
- 🔒 [حل مشاكل أمان المفاتيح](FIXING_API_KEY_ISSUE.md)
- 💡 [إعدادات آمنة متقدمة](SETUP_API_KEY.md)

---

## 🆘 إذا حدثت مشكلة

### ❌ "Invalid API Key"
- تأكد أنك نسخت المفتاح بشكل صحيح
- جرّب مفتاح جديد من Google

### ❌ "API not configured"
- تأكد أنك استخدمت `--dart-define` بشكل صحيح
- تحقق من عدم ترك مسافات

### ❌ "Connection timeout"
- تحقق من الإنترنت

---

## 🚀 الأوامر السريعة

```bash
# نظّف البناء القديم
flutter clean

# احصل على الحزم
flutter pub get

# شغّل مع المفتاح الجديد
flutter run --dart-define=GEMINI_API_KEY='YOUR_KEY'
```

---

## 📝 نسخة محلفوظة (.env)

إذا أردت أسهل:

1. أنشئ ملف `.env` في المجلد الرئيسي:
   ```
   GEMINI_API_KEY=AIzaSyABC...xyz
   ```

2. شغّل بشكل طبيعي:
   ```bash
   flutter run
   ```

---

**هل تحتاج مساعدة؟** اقرأ الملفات المرفقة أو اطلب المزيد من التوضيح 💬
