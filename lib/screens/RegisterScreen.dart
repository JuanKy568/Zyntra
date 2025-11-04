import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_text_field.dart';
import '../l10n/app_localizations.dart'; // 🌎 Traducciones

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedLevel = 'Recluta';
  bool _isLoading = false;

  /// 🔹 Guarda los datos del usuario en Firestore
  Future<void> _saveUserData({
    required String name,
    required String age,
    required String height,
    required String weight,
    required String level,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'age': int.tryParse(age) ?? 0,
        'height': double.tryParse(height) ?? 0.0,
        'weight': double.tryParse(weight) ?? 0.0,
        'level': level,
        'email': user.email,
        'coins': 0, // 💰 Monedas iniciales
        'ownedItems': <String>[], // 🎒 Accesorios
        'strengthExercises': <Map<String, dynamic>>[], // 🏋️‍♂️ Resistencia
        'nutritionPlans': <Map<String, dynamic>>[], // 🥗 Dietas
        'forceExercises': <Map<String, dynamic>>[], // 💪 Fuerza
        'strengthProgress': 0.0,
        'nutritionProgress': 0.0,
        'forceProgress': 0.0,
        // 🗓️ Campo nuevo: lista vacía de eventos planificados
        'events': <Map<String, dynamic>>[],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🔹 Registro del usuario con validaciones
  Future<void> _register() async {
    final loc = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      if (_passwordController.text.trim() !=
          _confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.passwordsDoNotMatch)),
        );
        setState(() => _isLoading = false);
        return;
      }

      // 🔹 Crear usuario en Firebase Auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 🔹 Guardar datos en Firestore
      await _saveUserData(
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        height: _heightController.text.trim(),
        weight: _weightController.text.trim(),
        level: _selectedLevel,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.userRegistered)),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Error';
      if (e.code == 'email-already-in-use') {
        message = 'Este correo ya está registrado';
      } else if (e.code == 'invalid-email') {
        message = loc.invalidEmail;
      } else if (e.code == 'weak-password') {
        message = loc.minCharacters;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                child: Icon(
                  Icons.person_add_alt,
                  size: 100,
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                loc.createAccount.toUpperCase(),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: theme.colorScheme.primary,
                  shadows: [
                    Shadow(
                      color: theme.colorScheme.secondary.withOpacity(0.6),
                      blurRadius: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 🔹 FORMULARIO DE REGISTRO
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: loc.fullName,
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value!.isEmpty ? loc.enterName : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _ageController,
                      label: loc.age,
                      icon: Icons.calendar_today_outlined,
                      validator: (value) =>
                          value!.isEmpty ? loc.enterAge : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _heightController,
                      label: loc.height,
                      icon: Icons.height,
                      validator: (value) =>
                          value!.isEmpty ? loc.enterHeight : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _weightController,
                      label: loc.weight,
                      icon: Icons.fitness_center,
                      validator: (value) =>
                          value!.isEmpty ? loc.enterWeight : null,
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Selector de nivel
                    DropdownButtonFormField<String>(
                      value: _selectedLevel,
                      decoration: InputDecoration(
                        labelText: loc.trainingLevel,
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF1A1A1F)
                            : Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      dropdownColor:
                          isDark ? const Color(0xFF1A1A1F) : Colors.white,
                      items: [
                        DropdownMenuItem(
                            value: 'Recluta', child: Text(loc.recruit)),
                        DropdownMenuItem(
                            value: 'Cadete', child: Text(loc.cadet)),
                        DropdownMenuItem(
                            value: 'Guerrero', child: Text(loc.warrior)),
                        DropdownMenuItem(
                            value: 'Gladiador', child: Text(loc.gladiator)),
                        DropdownMenuItem(
                            value: 'Élite', child: Text(loc.elite)),
                        DropdownMenuItem(
                            value: 'Maestro', child: Text(loc.master)),
                        DropdownMenuItem(
                            value: 'Titán', child: Text(loc.titan)),
                        DropdownMenuItem(
                            value: 'Leyenda', child: Text(loc.legend)),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedLevel = value!);
                      },
                    ),
                    const SizedBox(height: 16),

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
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      label: loc.confirmPassword,
                      icon: Icons.lock_reset_outlined,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) return loc.confirmYourPassword;
                        if (value != _passwordController.text) {
                          return loc.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          loc.register.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  loc.alreadyHaveAccount,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: theme.colorScheme.primary.withOpacity(0.4),
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
