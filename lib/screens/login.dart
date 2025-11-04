import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_text_field.dart';
import 'RegisterScreen.dart';
import 'UserDashboardScreen.dart';
import '../l10n/app_localizations.dart'; // Import para traducciones

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Inicia sesión con validación y manejo seguro de Firestore
  Future<void> _login() async {
    final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;
      if (user == null) throw FirebaseAuthException(code: 'no-user');

      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await userDoc.get();

      if (!doc.exists) {
        // 🔹 Si no hay documento, crea uno básico para evitar errores
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'coins': 0,
          'ownedItems': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // 🔹 Asegura que todos los campos críticos existan
      final data = (await userDoc.get()).data() ?? {};
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', data['name'] ?? '');
      await prefs.setString('age', data['age']?.toString() ?? '');
      await prefs.setString('height', data['height']?.toString() ?? '');
      await prefs.setString('weight', data['weight']?.toString() ?? '');
      await prefs.setString('level', data['level'] ?? '');
      await prefs.setInt('coins', data['coins'] ?? 0);
      await prefs.setStringList('ownedItems',
          List<String>.from(data['ownedItems'] ?? <String>[]));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.loginSuccess)),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = loc.loginError;
      if (e.code == 'user-not-found') message = 'Usuario no encontrado';
      if (e.code == 'wrong-password') message = 'Contraseña incorrecta';
      if (e.code == 'invalid-email') message = loc.invalidEmail;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      debugPrint('Error al iniciar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado al iniciar sesión.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌙 / ☀️ Botón de cambio de tema
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.wb_sunny
                          : Icons.nightlight_round,
                      color: themeProvider.isDarkMode
                          ? Colors.yellowAccent
                          : colorScheme.primary,
                      size: 28,
                    ),
                    tooltip: themeProvider.isDarkMode
                        ? 'Cambiar a tema claro'
                        : 'Cambiar a tema oscuro',
                    onPressed: themeProvider.toggleTheme,
                  ),
                ),

                // 🏋️‍♂️ Logo
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'ZYNTRA',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: colorScheme.primary,
                    shadows: [
                      Shadow(
                        color: colorScheme.secondary.withOpacity(0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // 🔹 Formulario de login
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: loc.email,
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value!.isEmpty) return loc.enterEmail;
                          if (!value.contains('@')) return loc.invalidEmail;
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: loc.password,
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return loc.enterPassword;
                          if (value.length < 6) return loc.minCharacters;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 Botón principal
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            loc.login.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Link a registro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    loc.noAccount,
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: colorScheme.primary.withOpacity(0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
