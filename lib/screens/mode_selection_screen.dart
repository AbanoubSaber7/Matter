// lib/screens/mode_selection_screen.dart 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/app_mode_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      appBar: AppBar(
        automaticallyImplyLeading: false, // remove back button from login
        title: const Text("YouMatter"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();

              // Clear local login state
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome to YouMatter",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF1DD1A1),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "How can we support you today?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              
              _buildModeButton(
                context,
                title: "Private Mode",
                subtitle: "A safe zone for reflection",
                icon: Icons.spa_outlined,
                color: const Color(0xFF1DD1A1),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1DD1A1), Color(0xFF00D2D3)],
                ),
                onTap: () {
                  context.read<AppModeProvider>().setMode(AppMode.private);
                  _navigateToChat(context);
                },
              ),
              
              const SizedBox(height: 24),
              
              _buildModeButton(
                context,
                title: "Emergency Mode",
                subtitle: "Immediate help & care alerts",
                icon: Icons.health_and_safety_outlined,
                color: const Color(0xFFFF6B6B),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                ),
                onTap: () {
                  context.read<AppModeProvider>().setMode(AppMode.emergency);
                  _navigateToChat(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  Widget _buildModeButton(BuildContext context, {
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color color,
    required LinearGradient gradient,
    required VoidCallback onTap
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle, 
                        style: TextStyle(
                          fontSize: 14, 
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white.withOpacity(0.8)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}