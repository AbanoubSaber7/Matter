import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // لفتح الاتصال مباشرة

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مصادر الدعم الموثوقة")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildResourceCard(
            "الخط الساخن للصحة النفسية",
            "16111", // رقم حكومي بمصر
            Icons.phone_in_talk,
          ),
          _buildResourceCard(
            "مستشفى العباسية للصحة النفسية",
            "0222616255",
            Icons.local_hospital,
          ),
          _buildResourceCard(
            "خدمات الإسعاف",
            "123",
            Icons.emergency,
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(String title, String phone, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFE8F8F5)],
          ),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1DD1A1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1DD1A1)),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1DD1A1),
            ),
          ),
          subtitle: Text(phone, style: const TextStyle(color: Color(0xFF636E72))),
          trailing: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1DD1A1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.call, color: Colors.white, size: 20),
          ),
          onTap: () => launchUrl(Uri.parse("tel:$phone")),
        ),
      ),
    );
  }
}