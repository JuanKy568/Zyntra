import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedLevel = 'Recluta';
  List<String> _ownedItems = [];
  bool _isLoading = true;

  // 🔹 Nuevos campos
  List<Map<String, dynamic>> strengthExercises = [];
  List<Map<String, dynamic>> nutritionPlans = [];
  List<Map<String, dynamic>> forceExercises = [];
  List<Map<String, dynamic>> events = []; // 🗓️ Lista de eventos personales

  double strengthProgress = 0.0;
  double nutritionProgress = 0.0;
  double forceProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 🔹 Carga los datos del usuario desde Firestore
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data() ?? {};

        setState(() {
          _nameController.text = (data['name'] ?? '').toString();
          _ageController.text = (data['age'] ?? '').toString();
          _heightController.text = (data['height'] ?? '').toString();
          _weightController.text = (data['weight'] ?? '').toString();
          _selectedLevel = (data['level'] ?? 'Recluta').toString();

          _ownedItems = List<String>.from(data['ownedItems'] ?? []);
          strengthExercises =
              List<Map<String, dynamic>>.from(data['strengthExercises'] ?? []);
          nutritionPlans =
              List<Map<String, dynamic>>.from(data['nutritionPlans'] ?? []);
          forceExercises =
              List<Map<String, dynamic>>.from(data['forceExercises'] ?? []);
          events = List<Map<String, dynamic>>.from(data['events'] ?? []); // 🗓️

          strengthProgress = (data['strengthProgress'] ?? 0.0).toDouble();
          nutritionProgress = (data['nutritionProgress'] ?? 0.0).toDouble();
          forceProgress = (data['forceProgress'] ?? 0.0).toDouble();
        });
      } else {
        // 🔹 Inicializa el documento si no existe
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'ownedItems': [],
          'strengthExercises': [],
          'nutritionPlans': [],
          'forceExercises': [],
          'events': [], // 🗓️ Lista vacía inicial de eventos
          'strengthProgress': 0.0,
          'nutritionProgress': 0.0,
          'forceProgress': 0.0,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// 🔹 Guarda los cambios del usuario
  Future<void> _saveUserData() async {
    if (!_formKey.currentState!.validate()) return;
    final loc = AppLocalizations.of(context)!;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'height': double.tryParse(_heightController.text.trim()) ?? 0.0,
        'weight': double.tryParse(_weightController.text.trim()) ?? 0.0,
        'level': _selectedLevel,
        // 🔹 Mantenemos las listas actuales
        'strengthExercises': strengthExercises,
        'nutritionPlans': nutritionPlans,
        'forceExercises': forceExercises,
        'events': events, // 🗓️ Guardamos los eventos
        'strengthProgress': strengthProgress,
        'nutritionProgress': nutritionProgress,
        'forceProgress': forceProgress,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.dataUpdated)),
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(loc.profileSettings),
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
                    _buildTextField(loc.name, _nameController, theme),
                    _buildTextField(loc.age, _ageController, theme,
                        keyboard: TextInputType.number),
                    _buildTextField(loc.height, _heightController, theme,
                        keyboard: TextInputType.number),
                    _buildTextField(loc.weight, _weightController, theme,
                        keyboard: TextInputType.number),
                    const SizedBox(height: 8),
                    _buildDropdownField(loc.trainingLevel, theme, loc),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _saveUserData,
                      icon: const Icon(Icons.save),
                      label: Text(loc.saveChanges),
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

  /// 🔹 Campo de texto reutilizable
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
          filled: true,
          fillColor: theme.brightness == Brightness.dark
              ? const Color(0xFF1A1A1F)
              : Colors.grey.shade200,
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

  /// 🔹 Dropdown con niveles normales y VIP (solo si fueron comprados)
  Widget _buildDropdownField(
      String label, ThemeData theme, AppLocalizations loc) {
    final colorScheme = theme.colorScheme;
    final textColor = theme.textTheme.bodyMedium?.color;

    final List<Map<String, dynamic>> availableLevels = [
      {'value': 'Recluta', 'label': loc.recruit},
      {'value': 'Cadete', 'label': loc.cadet},
      {'value': 'Guerrero', 'label': loc.warrior},
      {'value': 'Gladiador', 'label': loc.gladiator},
      {'value': 'Élite', 'label': loc.elite},
      {'value': 'Maestro', 'label': loc.master},
      {'value': 'Titán', 'label': loc.titan},
      {'value': 'Leyenda', 'label': loc.legend},
    ];

    if (_ownedItems.contains('titanGold')) {
      availableLevels.add({'value': 'vip1', 'label': 'VIP 1 (Titán Dorado)'});
    }
    if (_ownedItems.contains('cyberWarrior')) {
      availableLevels.add({'value': 'vip2', 'label': 'VIP 2 (Guerrero Cibernético)'});
    }
    if (_ownedItems.contains('masterPower')) {
      availableLevels.add({'value': 'vip3', 'label': 'VIP 3 (Maestro del Poder)'});
    }

    final bool levelAvailable =
        availableLevels.any((lvl) => lvl['value'] == _selectedLevel);
    if (!levelAvailable) _selectedLevel = 'Recluta';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedLevel,
        dropdownColor: theme.dialogBackgroundColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor?.withOpacity(0.7)),
          filled: true,
          fillColor: theme.brightness == Brightness.dark
              ? const Color(0xFF1A1A1F)
              : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: availableLevels
            .map<DropdownMenuItem<String>>(
              (lvl) => DropdownMenuItem<String>(
                value: lvl['value'] as String,
                child: Text(lvl['label'] as String),
              ),
            )
            .toList(),
        onChanged: (value) => setState(() => _selectedLevel = value!),
      ),
    );
  }
}
