import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_text_field.dart';
import 'RegisterScreen.dart';
import 'UserDashboardScreen.dart';

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

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = credential.user;
      if (user == null) throw FirebaseAuthException(code: 'no-user');

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', doc['name'] ?? '');
        await prefs.setString('age', doc['age'] ?? '');
        await prefs.setString('height', doc['height'] ?? '');
        await prefs.setString('weight', doc['weight'] ?? '');
        await prefs.setString('level', doc['level'] ?? '');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inicio de sesión exitoso ✅')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontraron datos del usuario en Firestore.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Error al iniciar sesión';
      if (e.code == 'user-not-found') message = 'Usuario no encontrado';
      if (e.code == 'wrong-password') message = 'Contraseña incorrecta';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🌙 / ☀️ Botón tema
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

                // 🏋️‍♂️ Logo con gradiente
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

                // 🔹 Título ZYNTRA
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

                // 🔹 Formulario
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        validator: (value) {
                          if (value!.isEmpty) return 'Ingrese su correo';
                          if (!value.contains('@')) return 'Correo inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return 'Ingrese su contraseña';
                          if (value.length < 6) return 'Mínimo 6 caracteres';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 🔹 Botón de inicio de sesión
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'INICIAR SESIÓN',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Ir al registro
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: Text(
                    '¿No tienes cuenta? Regístrate aquí',
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
