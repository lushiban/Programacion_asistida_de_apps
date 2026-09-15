import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Cancha · Fútbol',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1B8F2A),
        primary: const Color(0xFF1B8F2A),
        surface: const Color(0xFFF2F5E6),
      ),
      scaffoldBackgroundColor: const Color(0xFFF2F5E6),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF2F5E6),
        foregroundColor: Color(0xFF17351E),
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    home: const HomeScreen(),
  );
}
