import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_mode_provider.dart';
import '../models/message.dart';
import '../models/risk_assessment.dart';
import '../providers/user_provider.dart';

import '../services/risk_engine.dart'; // تأكد من إنشاء هذا الملف
import 'emergency_contacts_screen.dart';
import 'resources_screen.dart';
import 'profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import '../services/gemini_service.dart';
import 'api_key_screen.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final GeminiService _geminiService = GeminiService();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndPromptTrustedContact();
    });
  }

  void _confirmNewChat() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('بدء دردشة جديدة'),
          content: const Text('هل تريد مسح المحادثة الحالية والبدء من جديد؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewChat();
              },
              child: const Text('نعم، ابدأ جديد'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _startNewChat() async {
    final firestoreService = FirestoreService();
    await firestoreService.clearChatMessages();
    _geminiService.resetChat();
    if (!mounted) return;
    setState(() {
      _messages.clear();
      _isTyping = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم بدء دردشة جديدة بنجاح')),
    );
  }

  void _loadMessages() {
    FirestoreService().getChatMessages().listen((snapshot) {
      if (mounted) {
        setState(() {
          _messages.clear();
          for (var doc in snapshot.docs) {
            _messages.add(ChatMessage.fromMap(doc.data() as Map<String, dynamic>));
          }
        });
      }
    });
  }

  Future<void> _checkAndPromptTrustedContact() async {
    final appMode = context.read<AppModeProvider>().currentMode;
    if (appMode == AppMode.emergency) {
      final firestoreService = FirestoreService();
      try {
        final stream = firestoreService.getTrustedContacts();
        final snapshot = await stream.first;
        if (snapshot.docs.isEmpty) {
          if (!mounted) return;
          _showAddTrustedContactDialog();
        }
      } catch (e) {
        print("Error checking contacts: $e");
      }
    }
  }

  void _showAddTrustedContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.warning_rounded, color: Color(0xFFFF6B6B)),
                  SizedBox(width: 8),
                  Text("Trusted Contact"),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("To use Priority Support safely, please add at least one trusted contact who will be notified if you're in danger."),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Contact Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () {
                    Navigator.pop(context);
                  },
                  child: const Text("Later", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: isSaving ? null : () async {
                    if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill all fields")),
                      );
                      return;
                    }
                    
                    setDialogState(() => isSaving = true);
                    final firestoreService = FirestoreService();
                    await firestoreService.addTrustedContact(nameController.text.trim(), phoneController.text.trim());
                    
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Trusted contact added successfully!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isSaving 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  // دالة التعامل مع إرسال الرسائل بنظام موفر للحصة (Optimized)
  Future<void> _handleSend() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() => _isTyping = true);

    // حفظ رسالة المستخدم في Firestore
    final firestoreService = FirestoreService();
    await firestoreService.saveChatMessage(text, MessageSender.user.index);

    // 1. فحص بسيط لتوفير الحصة (إذا كانت الرسالة مجرد سلام)
    final greetings = ["هلا", "هلو", "السلام عليكم", "سلام", "hi", "hello", "hey"];
    if (greetings.contains(text.toLowerCase())) {
      await firestoreService.saveChatMessage("أهلاً بك! أنا هنا للاستماع إليك. كيف يمكنني مساعدتك اليوم؟", MessageSender.bot.index);
      if (mounted) setState(() => _isTyping = false);
      return;
    }

    // 2. تحليل مستوى الخطر (محلياً فوراً للسرعة والأمان)
    RiskAssessment riskAssessment = RiskEngine.analyzeText(text);
    if (riskAssessment.level == RiskLevel.critical || riskAssessment.level == RiskLevel.high) {
      _handleRiskLevel(riskAssessment); // إظهار التنبيه فوراً
    }

    // 3. طلب الرد من جوجل (لتوفير الحصة)
    final result = await _geminiService.analyzeAndReply(text);
    String aiRisk = result["risk"] ?? "LOW";
    String botReply = result["reply"] ?? "";

    // تحديث مستوى الخطر إذا وجد الذكاء الاصطناعي شيئاً إضافياً (Critical أو High)
    if (aiRisk.contains("CRITICAL") && riskAssessment.level != RiskLevel.critical) {
      riskAssessment = riskAssessment.copyWith(level: RiskLevel.critical);
      _handleRiskLevel(riskAssessment);
    } else if (aiRisk.contains("HIGH") && riskAssessment.level != RiskLevel.high && riskAssessment.level != RiskLevel.critical) {
      riskAssessment = riskAssessment.copyWith(level: RiskLevel.high);
      _handleRiskLevel(riskAssessment);
    }

    // حفظ رد البوت في Firestore
    await firestoreService.saveChatMessage(botReply, MessageSender.bot.index);

    if (mounted) {
      setState(() => _isTyping = false);
    }
  }

  /// التعامل مع مستويات الخطر المختلفة
  void _handleRiskLevel(RiskAssessment assessment) {
    final appMode = context.read<AppModeProvider>().currentMode;
    
    switch (assessment.level) {
      case RiskLevel.critical:
        _showCriticalRiskAlert(assessment);
        if (appMode == AppMode.emergency) {
          _sendEmergencySMS(assessment);
        }
        break;
        
      case RiskLevel.high:
        _showHighRiskAlert(assessment);
        _sendEmergencySMS(assessment);
        break;
        
      case RiskLevel.medium:
        _showMediumRiskAlert(assessment);
        break;
        
      case RiskLevel.low:
        // لا نحتاج لتنبيه لرسائل عادية
        break;
    }
  }

  /// عرض تنبيه للخطر الحرج
  void _showCriticalRiskAlert(RiskAssessment assessment) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF5F5),
        title: const Row(
          children: [
            Icon(Icons.emergency_rounded, color: Color(0xFFFF6B6B), size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "🚨 خطر حرج - تنبيه طوارئ",
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assessment.reason,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📋 التوصيات المقترحة:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...assessment.recommendations.map((rec) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text("• $rec"),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("فهمت"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResourcesScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: const Text(
              "أرقام الخط الساخن والمساعدة",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// عرض تنبيه للخطر العالي
  void _showHighRiskAlert(RiskAssessment assessment) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF9E6),
        title: Row(
          children: const [
            Icon(Icons.warning_rounded, color: Color(0xFFFF9800), size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "⚠️ خطر عالي",
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assessment.reason,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "💡 النصائح:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    ...assessment.recommendations.take(3).map((rec) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text("• $rec", style: const TextStyle(fontSize: 12)),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("حسناً"),
          ),
        ],
      ),
    );
  }

  /// عرض تنبيه للخطر المتوسط
  void _showMediumRiskAlert(RiskAssessment assessment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "⚡ ملاحظة",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    assessment.reason,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF9800),
        duration: const Duration(seconds: 4),
      ),
    );
  }


  // إرسال رسالة SMS مع تفاصيل التقييم
  Future<void> _sendEmergencySMS(RiskAssessment assessment) async {
    final Telephony telephony = Telephony.instance;
    final FirestoreService firestoreService = FirestoreService();

    try {
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      if (permissionsGranted == true) {
        // جلب جهات الاتصال من Firebase
        final snapshot = await firestoreService.getTrustedContacts().first;

        if (snapshot.docs.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("⚠️ يرجى إضافة رقم موثوق من القائمة الجانبية لإرسال التنبيه"),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        String riskLevel = assessment.level == RiskLevel.critical ? "🚨 حرج" : "⚠️ عالي";
        String message = "تنبيه طوارئ من YouMatter:\nالمستخدم في حالة $riskLevel ويحتاج لدعمك.\nيرجى التواصل معه فوراً.";
        
        for (var doc in snapshot.docs) {
          String phone = doc['phone'];
          String name = doc['name'];
          if (phone.isNotEmpty) {
            try {
              await telephony.sendSms(to: phone, message: message);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("✅ تم إرسال تنبيه لـ $name"), backgroundColor: Colors.green),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ فشل الإرسال لـ $name"), backgroundColor: Colors.red),
                );
              }
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠️ التطبيق لا يملك صلاحية إرسال الرسائل"), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      print("Error in emergency SMS: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appMode = context.watch<AppModeProvider>().currentMode;
    final isEmergency = appMode == AppMode.emergency;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'دردشة جديدة',
            onPressed: _confirmNewChat,
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEmergency ? "دعم ذو أولوية" : "مساحة خاصة",
              style: TextStyle(
                color: isEmergency ? const Color(0xFFFF6B6B) : const Color(0xFF1DD1A1),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isEmergency ? "نحن هنا من أجلك" : "رفيقك الذكي يستمع إليك",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: const Color(0xFF636E72),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 1,
        iconTheme: IconThemeData(
          color: isEmergency ? const Color(0xFFFF6B6B) : const Color(0xFF1DD1A1),
        ),
      ),
      
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isEmergency
                      ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A6F)]
                      : [const Color(0xFF1DD1A1), const Color(0xFF00D2D3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.self_improvement_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProvider.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userProvider.email,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawerItem(
              icon: Icons.person_outline,
              title: "ملفي الشخصي",
              color: const Color(0xFF1DD1A1),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
            ),
            // Trusted Contacts - Only show in Emergency mode
            if (isEmergency)
              _buildDrawerItem(
                icon: Icons.contact_phone_outlined,
                title: "جهات الاتصال الموثوقة",
                color: const Color(0xFFFF6B6B),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()));
                },
              ),
            _buildDrawerItem(
              icon: Icons.help_outline,
              title: "موارد الدعم",
              color: const Color(0xFF1DD1A1),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ResourcesScreen()));
              },
            ),
            _buildDrawerItem(
              icon: Icons.vpn_key_outlined,
              title: "إعداد API Key",
              color: const Color(0xFF1DD1A1),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push<bool?>(
                  context,
                  MaterialPageRoute(builder: (context) => const ApiKeyScreen()),
                );
                if (result == true) {
                  await _geminiService.reloadApiKey();
                }
              },
            ),
            const Divider(height: 32, thickness: 1, color: Color(0xFFF0F0F0)),
            _buildDrawerItem(
              icon: Icons.logout_rounded,
              title: "تسجيل الخروج",
              color: Colors.grey,
              onTap: () async {
                // Sign out logic
                await FirebaseAuth.instance.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);

                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: _messages.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _buildMessageTile(_messages[index], isEmergency),
              ),
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "جاري الرد...",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          _buildInputArea(isEmergency),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D3436),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildMessageTile(ChatMessage message, bool isEmergency) {
    bool isUser = message.sender == MessageSender.user;
    String formattedTime = DateFormat('hh:mm a').format(message.timestamp);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? (isEmergency ? const Color(0xFFFF6B6B) : const Color(0xFF1DD1A1)) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isUser ? Colors.white : const Color(0xFF2D3436),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedTime,
              style: TextStyle(
                color: isUser ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isEmergency) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF1DD1A1).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "اكتب ما تشعر به...",
                    hintStyle: TextStyle(color: Color(0xFF95A5A6)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  style: const TextStyle(color: Color(0xFF2D3436)),
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isEmergency
                      ? [const Color(0xFFFF6B6B), const Color(0xFFEE5A6F)]
                      : [const Color(0xFF1DD1A1), const Color(0xFF00D2D3)],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white),
                onPressed: _handleSend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}