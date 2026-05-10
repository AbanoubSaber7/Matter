// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_mode_provider.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';

import 'config/api_keys.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiKeys.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppModeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const YouMatterApp(),
    ),
  );
}

class YouMatterApp extends StatelessWidget {
  const YouMatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouMatter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1DD1A1),
          primary: const Color(0xFF1DD1A1), // Vibrant Green - Hope & Energy
          secondary: const Color(0xFFFF6B6B), // Warm Orange-Red - Positivity
          background: const Color(0xFFF0F9FF), // Bright Sky Blue - Calm & Serene
          tertiary: const Color(0xFFFFD93D), // Warm Yellow - Joy & Happiness
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Color(0xFF1DD1A1)), // Vibrant Green
          titleTextStyle: TextStyle(
            color: Color(0xFF1DD1A1),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2D3436)),
          bodyMedium: TextStyle(color: Color(0xFF636E72)),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}