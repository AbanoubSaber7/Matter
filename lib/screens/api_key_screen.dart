import 'package:flutter/material.dart';
import '../config/api_keys.dart';

class ApiKeyScreen extends StatefulWidget {
  const ApiKeyScreen({super.key});

  @override
  State<ApiKeyScreen> createState() => _ApiKeyScreenState();
}

class _ApiKeyScreenState extends State<ApiKeyScreen> {
  final TextEditingController _keyController = TextEditingController();
  bool _isLoading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentKey();
  }

  Future<void> _loadCurrentKey() async {
    final key = ApiKeys.geminiApiKey;
    _keyController.text = key;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveKey() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('من فضلك أدخل مفتاح API صالح.')),
      );
      return;
    }

    setState(() => _saving = true);
    await ApiKeys.saveApiKey(key);
    setState(() => _saving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ مفتاح API بنجاح.')),
    );
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _clearKey() async {
    setState(() => _saving = true);
    await ApiKeys.clearApiKey();
    _keyController.clear();
    setState(() => _saving = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف مفتاح API.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات Gemini API Key'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'أدخل مفتاح Gemini API الخاص بك هنا. هذا يسمح للتطبيق بالتواصل مع خدمة الذكاء الاصطناعي مباشرة.',
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _keyController,
                    decoration: const InputDecoration(
                      labelText: 'Gemini API Key',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saving ? null : _saveKey,
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('حفظ المفتاح'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _saving ? null : _clearKey,
                    child: const Text('مسح المفتاح الحالي'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'إذا ظهر خطأ "API key not valid"، تأكد من أن المفتاح صالح وغير مقيد من Google Cloud.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
    );
  }
}
