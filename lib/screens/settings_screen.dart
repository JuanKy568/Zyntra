import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _selectedLevel = 'Intermedio';

  bool _isLoading = true;

  final List<String> _levels = [
    'Principiante',
    'Intermedio',
    'Avanzado',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = data['age'] ?? '';
          _heightController.text = data['height'] ?? '';
          _weightController.text = data['weight'] ?? '';
          _selectedLevel = data['level'] ?? 'Intermedio';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim(),
        'height': _heightController.text.trim(),
        'weight': _weightController.text.trim(),
        'level': _selectedLevel,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos actualizados correctamente ✅')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    //final textColor = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Configuración de Perfil'),
        backgroundColor: colorScheme.primary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField('Nombre', _nameController, theme),
                    _buildTextField('Edad', _ageController, theme,
                        keyboard: TextInputType.number),
                    _buildTextField('Altura (m)', _heightController, theme,
                        keyboard: TextInputType.number),
                    _buildTextField('Peso (kg)', _weightController, theme,
                        keyboard: TextInputType.number),
                    const SizedBox(height: 8),
                    _buildDropdownField('Nivel', theme),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _saveUserData,
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar cambios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    ThemeData theme, {
    TextInputType keyboard = TextInputType.text,
  }) {
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor?.withOpacity(0.7)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildDropdownField(String label, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedLevel,
        dropdownColor: theme.dialogBackgroundColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor?.withOpacity(0.7)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: _levels
            .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level, style: TextStyle(color: textColor)),
                ))
            .toList(),
        onChanged: (value) => setState(() => _selectedLevel = value!),
      ),
    );
  }
}
