import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 asegúrate de tener este archivo (lo genera flutterfire)
import 'screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app(); // usa la instancia ya existente
    }
  } catch (e) {
    Firebase.app(); // fallback si ya está inicializado
  }
  
  runApp(const KraftDriveApp());
}

class KraftDriveApp extends StatelessWidget {
  const KraftDriveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kraft Drive',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1E88E5),
          secondary: Color(0xFF90CAF9),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
