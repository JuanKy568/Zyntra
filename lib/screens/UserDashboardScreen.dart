import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  String avatarPath = 'assets/recluta.glb';
  Key avatarKey = UniqueKey(); // 🔹 clave única para forzar recarga del avatar

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 🔹 Carga datos del usuario y actualiza avatar según nivel
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        age = data['age']?.toString() ?? '';
        height = data['height']?.toString() ?? '';
        weight = data['weight']?.toString() ?? '';
        level = data['level'] ?? 'Recluta';
        avatarPath = _getAvatarPath(level);
        avatarKey = UniqueKey(); // 🔹 cambia la clave para recargar el modelo
      });
    }
  }

  /// 🔹 Devuelve el modelo .glb según el nivel del usuario
  String _getAvatarPath(String level) {
    switch (level.toLowerCase()) {
      case 'recluta':
        return 'assets/recluta.glb';
      case 'cadete':
        return 'assets/cadete.glb';
      case 'guerrero':
        return 'assets/guerrero.glb';
      case 'gladiador':
        return 'assets/gladiador.glb';
      case 'élite':
      case 'elite':
        return 'assets/elite.glb';
      case 'maestro':
        return 'assets/maestro.glb';
      case 'titán':
      case 'titan':
        return 'assets/titan.glb';
      case 'leyenda':
        return 'assets/leyenda.glb';
      default:
        return 'assets/recluta.glb';
    }
  }

  /// 🔹 Cerrar sesión
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
        title: Text(
          'Mi Gimnasio Virtual',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Avatar dinámico con recarga visual forzada
            SizedBox(
              height: 300,
              child: ModelViewer(
                key: avatarKey, // 👈 esta clave fuerza que el widget se reconstruya
                src: avatarPath,
                alt: "Avatar del usuario ($level)",
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: isDark
                  ? const Color(0xFF1E1E24)
                  : Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información del Usuario',
                      style: TextStyle(
                        color: colorScheme.primary,
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

                  // 🔹 Si el usuario guardó cambios, recargamos datos y avatar
                  if (result == true) {
                    await _loadUserData();
                  }
                }),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, [VoidCallback? onTap]) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
      ),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(color: colorScheme.onBackground.withOpacity(0.7))),
          Text(value, style: TextStyle(color: colorScheme.onBackground)),
        ],
      ),
    );
  }
}
