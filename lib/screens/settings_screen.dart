import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final _levelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? 'Juan Díaz';
      _ageController.text = prefs.getString('age') ?? '25';
      _heightController.text = prefs.getString('height') ?? '1.75';
      _weightController.text = prefs.getString('weight') ?? '72';
      _levelController.text = prefs.getString('level') ?? 'Intermedio';
    });
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('age', _ageController.text);
      await prefs.setString('height', _heightController.text);
      await prefs.setString('weight', _weightController.text);
      await prefs.setString('level', _levelController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados correctamente')),
        );
        Navigator.pop(context, true); // Retorna al dashboard
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Configuración de Perfil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Nombre', _nameController),
              _buildTextField('Edad', _ageController, keyboard: TextInputType.number),
              _buildTextField('Altura (m)', _heightController, keyboard: TextInputType.number),
              _buildTextField('Peso (kg)', _weightController, keyboard: TextInputType.number),
              _buildTextField('Nivel', _levelController),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveUserData,
                icon: const Icon(Icons.save),
                label: const Text('Guardar cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white30),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }
}
