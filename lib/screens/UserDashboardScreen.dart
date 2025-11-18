import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';
import 'login.dart';
import 'store_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import '../l10n/app_localizations.dart';
import 'progress_screen.dart';
import 'screen_friends.dart';


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
  List<String> ownedItems = [];

  Key avatarKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// 🔹 Cargar datos del usuario desde Firestore
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        age = data['age']?.toString() ?? '';
        height = data['height']?.toString() ?? '';
        weight = data['weight']?.toString() ?? '';
        final rawLevel = (data['level'] ?? 'recruit').toString().toLowerCase();
        switch (rawLevel) {
          case 'recluta': level = 'recruit'; break;
          case 'cadete': level = 'cadet'; break;
          case 'guerrero': level = 'warrior'; break;
          case 'gladiador': level = 'gladiator'; break;
          case 'élite':
          case 'elite': level = 'elite'; break;
          case 'maestro': level = 'master'; break;
          case 'titán':
          case 'titan': level = 'titan'; break;
          case 'leyenda': level = 'legend'; break;
          default: level = rawLevel;
        }
        ownedItems = List<String>.from(data['ownedItems'] ?? []);
        avatarPath = _getAvatarPath(level);
        avatarKey = UniqueKey();
      });
    }
  }

  /// 🔹 Devuelve el modelo base según el nivel o avatar VIP
  String _getAvatarPath(String level) {
    switch (level.toLowerCase()) {

      // 🔹 VIP levels (solo en inglés)
      case 'vip1':
        return 'assets/store/vip1.glb';
      case 'vip2':
        return 'assets/store/vip2.glb';
      case 'vip3':
        return 'assets/store/vip3.glb';

      // 🔹 Recruit (recluta)
      case 'recluta':
      case 'recruit':
        return 'assets/recluta.glb';

      // 🔹 Cadet (cadete)
      case 'cadete':
      case 'cadet':
        return 'assets/cadete.glb';

      // 🔹 Warrior (guerrero)
      case 'guerrero':
      case 'warrior':
        return 'assets/guerrero.glb';

      // 🔹 Gladiator (gladiador)
      case 'gladiador':
      case 'gladiator':
        return 'assets/gladiador.glb';

      // 🔹 Elite (élite)
      case 'élite':
      case 'elite':
        return 'assets/elite.glb';

      // 🔹 Master (maestro)
      case 'maestro':
      case 'master':
        return 'assets/maestro.glb';

      // 🔹 Titan (titán)
      case 'titán':
      case 'titan':
        return 'assets/titan.glb';

      // 🔹 Legend (leyenda)
      case 'leyenda':
      case 'legend':
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

  /// 🔹 Widget combinado del avatar, VIP y accesorios
  Widget _buildAvatarWithAccessories() {
    List<Widget> models = [];

    // 🧍 Modelo base o VIP activo
    models.add(
      Positioned.fill(
        child: ModelViewer(
          key: avatarKey,
          src: avatarPath,
          alt: "Avatar del usuario ($level)",
          autoRotate: true,
          cameraControls: true,
          backgroundColor: Colors.transparent,
        ),
      ),
    );

    // 👑 Corona (izquierda)
    if (ownedItems.contains('gripGloves')) {
      models.add(Positioned(
        top: 60,
        left: 30,
        height: 120,
        width: 120,
        child: ModelViewer(
          src: 'assets/store/obj1.glb',
          alt: "Corona lateral",
          autoRotate: false,
          cameraControls: false,
          backgroundColor: Colors.transparent,
        ),
      ));
    }

    // 🧞 Alfombra (debajo)
    if (ownedItems.contains('powerBelt')) {
      models.add(Positioned(
        bottom: -40,
        left: 40,
        right: 40,
        height: 100,
        child: ModelViewer(
          src: 'assets/store/obj2.glb',
          alt: "Alfombra mágica",
          autoRotate: false,
          cameraControls: false,
          backgroundColor: Colors.transparent,
        ),
      ));
    }

    // 🎮 Control gamer (derecha)
    if (ownedItems.contains('nonSlipBoots')) {
      models.add(Positioned(
        right: 10,
        bottom: 40,
        height: 100,
        width: 100,
        child: ModelViewer(
          src: 'assets/store/obj3.glb',
          alt: "Control gamer",
          autoRotate: false,
          cameraControls: false,
          backgroundColor: Colors.transparent,
        ),
      ));
    }

    return SizedBox(
      height: 350,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: models,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(isDark ? 0.2 : 0.1),
        title: Text(
          loc.gymTitle,
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
            // 🔹 Avatar con accesorios o VIP
            _buildAvatarWithAccessories(),
            const SizedBox(height: 20),

            // 🔹 Tarjeta de información del usuario
            Card(
              color: isDark ? const Color(0xFF1E1E24) : Colors.grey.shade100,
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
                      loc.userInfo,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InfoRow(label: loc.name, value: name),
                    InfoRow(label: loc.age, value: "$age ${loc.years}"),
                    InfoRow(label: loc.height, value: "$height m"),
                    InfoRow(label: loc.weight, value: "$weight kg"),
                    InfoRow(
                      label: loc.level,
                      value: _getLevelDisplayName(level),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Botones de acciones
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildActionButton(
                  Icons.fitness_center,
                  loc.trainings,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ChatScreen()),
                    );
                  },
                ),
                _buildActionButton(
                  Icons.show_chart,
                  loc.progress,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProgressScreen()),
                    );
                  },
                ),
                _buildActionButton(
                  Icons.store,
                  loc.store,
                  () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StoreScreen()),
                    );
                    await _loadUserData();
                  },
                ),
                _buildActionButton(
                  Icons.settings,
                  loc.settings,
                  () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                    if (result == true) await _loadUserData();
                  },
                ),

                // ⭐ NUEVO BOTÓN DE AMIGOS ⭐
                _buildActionButton(
                  Icons.group,
                  loc.friends,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FriendsScreen()),
                    );
                  },
                ),
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
              label: Text(
                loc.logout,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Mostrar nombre legible del nivel VIP o normal
  String _getLevelDisplayName(String lvl) {
    switch (lvl.toLowerCase()) {
      case 'vip1':
        return 'VIP 1';
      case 'vip2':
        return 'VIP 2';
      case 'vip3':
        return 'VIP 3';
      default:
        return lvl;
    }
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
          Text(
            label,
            style: TextStyle(color: colorScheme.onBackground.withOpacity(0.7)),
          ),
          Text(
            value,
            style: TextStyle(color: colorScheme.onBackground),
          ),
        ],
      ),
    );
  }
}
