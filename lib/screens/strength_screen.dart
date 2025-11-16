import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';

final Map<String, String Function(AppLocalizations loc)> strengthKeys = {
  "r_name1": (loc) => loc.r_name1,
  "r_description1": (loc) => loc.r_description1,
  "r_name2": (loc) => loc.r_name2,
  "r_description2": (loc) => loc.r_description2,
  "r_name3": (loc) => loc.r_name3,
  "r_description3": (loc) => loc.r_description3,
  "r_name4": (loc) => loc.r_name4,
  "r_description4": (loc) => loc.r_description4,
};

/// Traducción segura
String t(AppLocalizations loc, String? key) {
  if (key == null) return "";
  return strengthKeys[key]?.call(loc) ?? key;
}

class StrengthScreen extends StatefulWidget {
  const StrengthScreen({super.key});

  @override
  State<StrengthScreen> createState() => _StrengthScreenState();
}

class _StrengthScreenState extends State<StrengthScreen> {
  List<Map<String, dynamic>> exercises = [
    {
      "nameKey": "r_name1",
      "descKey": "r_description1",
      "image": "assets/exercises/walk.png",
      "increase": 0.05
    },
    {
      "nameKey": "r_name2",
      "descKey": "r_description2",
      "image": "assets/exercises/jump_rope.png",
      "increase": 0.08
    },
    {
      "nameKey": "r_name3",
      "descKey": "r_description3",
      "image": "assets/exercises/cycling.png",
      "increase": 0.10
    },
    {
      "nameKey": "r_name4",
      "descKey": "r_description4",
      "image": "assets/exercises/stairs.png",
      "increase": 0.07
    },
  ];

  double currentProgress = 0.0;
  int userCoins = 0;
  bool _loading = true;
  late String userId;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    userId = user.uid;
    await _loadProgressAndExercises();
  }

  Future<void> _loadProgressAndExercises() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        final userExercises =
            List<Map<String, dynamic>>.from(data['strengthExercises'] ?? []);
        final progress = (data['strengthProgress'] ?? 0.0).toDouble();
        final coins = (data['coins'] ?? 0).toInt();

        setState(() {
          exercises = [...exercises, ...userExercises];
          currentProgress = progress;
          userCoins = coins;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint("Error al cargar progreso o ejercicios: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _saveExercisesToFirestore() async {
    try {
      final customExercises = exercises
          .where((e) => e["image"] == "assets/exercises/custom.png")
          .toList();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'strengthExercises': customExercises,
      });
    } catch (e) {
      debugPrint("Error al guardar ejercicios: $e");
    }
  }

  Future<void> _updateProgress(double increment) async {
    double newProgress = currentProgress + increment;
    int earnedCoins = 0;
    final loc = AppLocalizations.of(context)!;

    if (newProgress >= 1.0) {
      earnedCoins = 100;
      newProgress -= 1.0;
    }

    try {
      final newCoins = userCoins + earnedCoins;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'strengthProgress': newProgress,
        'coins': newCoins,
      });

      setState(() {
        currentProgress = newProgress;
        userCoins = newCoins;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              earnedCoins > 0 ? loc.congratulations : loc.excellent),
          backgroundColor:
              earnedCoins > 0 ? Colors.amber.shade700 : Colors.green,
        ),
      );
    } catch (e) {
      debugPrint("Error al actualizar progreso: $e");
    }
  }

  Future<void> _addCustomExercise(BuildContext context) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final increaseController = TextEditingController();
    final loc = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)),
          title: Text(loc.add),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: loc.name_add),
                ),
                TextField(
                  controller: descController,
                  decoration:
                      InputDecoration(labelText: loc.des_add),
                ),
                TextField(
                  controller: increaseController,
                  decoration: InputDecoration(
                      labelText: loc.aum_add),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.btn_cancel)),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final desc = descController.text.trim();
                final inc =
                    double.tryParse(increaseController.text) ?? 0.05;

                if (name.isEmpty || desc.isEmpty) return;

                final newExercise = {
                  "name": name,
                  "description": desc,
                  "image": "assets/exercises/custom.png",
                  "increase": inc.clamp(0.01, 0.2),
                };

                setState(() => exercises.add(newExercise));

                await _saveExercisesToFirestore();
                Navigator.pop(context);
              },
              child: Text(loc.btn_add),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    if (_loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        title: Text(loc.training),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCustomExercise(context),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            // 🔹 Barra de progreso
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.progress_r,
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: currentProgress,
                        minHeight: 12,
                        backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(height: 6),
                      Text("${(currentProgress * 100).toStringAsFixed(1)}%"),
                      const SizedBox(height: 10),
                      Text("${loc.coins}: $userCoins 🪙",
                          style: TextStyle(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Lista de ejercicios
            ...exercises.map((item) {
              final isTranslated = item.containsKey("nameKey");

              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(item["image"]),
                        radius: 28,
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTranslated
                                  ? t(loc, item["nameKey"])
                                  : item["name"],
                              style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isTranslated
                                  ? t(loc, item["descKey"])
                                  : item["description"],
                              style: TextStyle(
                                  color: colorScheme.onBackground
                                      .withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        children: [
                          Text(
                            "+${(item["increase"] * 100).toInt()}%",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill,
                                color: Colors.blueAccent, size: 28),
                            onPressed: () =>
                                _updateProgress(item["increase"]),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
