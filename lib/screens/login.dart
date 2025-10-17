import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'RegisterScreen.dart';
import 'UserDashboardScreen.dart'; // 🔹 Importamos la nueva pantalla del usuario

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
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso ✅')),
        );

        // 🔹 Redirige al Dashboard del usuario
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF7A00FF), Color(0xFF00D1FF)],
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
              const Text(
                'ZYNTRA',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xFF9B4DFF),
                  shadows: [
                    Shadow(
                      color: Color(0xFF00E5FF),
                      blurRadius: 20,
                      offset: Offset(0, 0),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A00FF),
                    shadowColor: const Color(0xFF00E5FF),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'INICIAR SESIÓN',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Botón para ir al registro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  '¿No tienes cuenta? Regístrate aquí',
                  style: TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Color(0xFF7A00FF),
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
    );
  }
}
