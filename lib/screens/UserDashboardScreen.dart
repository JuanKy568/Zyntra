import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  String name = '';
  String age = '';
  String height = '';
  String weight = '';
  String level = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Juan Díaz';
      age = prefs.getString('age') ?? '25';
      height = prefs.getString('height') ?? '1.75';
      weight = prefs.getString('weight') ?? '72';
      level = prefs.getString('level') ?? 'Intermedio';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 38, 38),
        title: const Text('Mi Gimnasio Virtual'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: ModelViewer(
                src: 'assets/avocadoCharacter.glb',
                alt: "Avatar del usuario",
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información del Usuario',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoRow(label: "Nombre", value: name),
                    InfoRow(label: "Edad", value: "$age años"),
                    InfoRow(label: "Altura", value: "$height m"),
                    InfoRow(label: "Peso", value: "$weight kg"),
                    InfoRow(label: "Nivel", value: level),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(Icons.fitness_center, 'Entrenamientos'),
                _buildActionButton(Icons.show_chart, 'Progreso'),
                _buildActionButton(Icons.store, 'Tienda'),
                _buildActionButton(Icons.settings, 'Configuración', () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                  if (result == true) {
                    _loadUserData(); // Actualiza los datos al volver
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, [VoidCallback? onTap]) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
