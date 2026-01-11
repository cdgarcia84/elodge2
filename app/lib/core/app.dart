import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modules/auth/login_screen.dart';
import '../modules/dashboard/dashboard_screen.dart';
import 'session.dart';

class ElodgeApp extends StatefulWidget {
  const ElodgeApp({super.key});

  @override
  State<ElodgeApp> createState() => _ElodgeAppState();
}

class _ElodgeAppState extends State<ElodgeApp> {
  UserSession? _session;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELODGE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A5F),
          primary: const Color(0xFF274C77),
          secondary: const Color(0xFF6096BA),
          surface: const Color(0xFFF7F9FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        textTheme: GoogleFonts.manropeTextTheme().apply(
          bodyColor: const Color(0xFF0F1F2E),
          displayColor: const Color(0xFF0F1F2E),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF2F5FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        useMaterial3: true,
      ),
      home: _session == null
          ? LoginScreen(
              onLogin: (session) {
                setState(() => _session = session);
              },
            )
          : DashboardScreen(
              session: _session!,
              onLogout: () => setState(() => _session = null),
            ),
    );
  }
}
