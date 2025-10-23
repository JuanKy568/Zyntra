import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/splash.dart';
import 'providers/theme_provider.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }
  } catch (e) {
    Firebase.app();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const KraftDriveApp(),
    ),
  );
}

class KraftDriveApp extends StatelessWidget {
  const KraftDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final lightTheme = ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF7A00FF),
        secondary: Color(0xFF00E5FF),
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelStyle: const TextStyle(color: Colors.black87),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A00FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF7A00FF),
        foregroundColor: Colors.white,
      ),
    );

    final darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7A00FF),
        secondary: Color(0xFF00E5FF),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0A0F),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1A1F),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7A00FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0F),
        foregroundColor: Colors.white,
      ),
    );

    return AnimatedTheme(
      duration: const Duration(milliseconds: 400),
      data: themeProvider.isDarkMode ? darkTheme : lightTheme,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zyntra',
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
