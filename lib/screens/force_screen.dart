import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';

final Map<String, String Function(AppLocalizations loc)> forceKeys = {
  "f_name1":  (loc) => loc.f_name1,
  "f_desc1":  (loc) => loc.f_desc1,
  "f_name2":  (loc) => loc.f_name2,
  "f_desc2":  (loc) => loc.f_desc2,
  "f_name3":  (loc) => loc.f_name3,
  "f_desc3":  (loc) => loc.f_desc3,
  "f_name4":  (loc) => loc.f_name4,
  "f_desc4":  (loc) => loc.f_desc4,
  "f_name5":  (loc) => loc.f_name5,
  "f_desc5":  (loc) => loc.f_desc5,
  "f_name6":  (loc) => loc.f_name6,
  "f_desc6":  (loc) => loc.f_desc6,
  "f_name7":  (loc) => loc.f_name7,
  "f_desc7":  (loc) => loc.f_desc7,
  "f_name8":  (loc) => loc.f_name8,
  "f_desc8":  (loc) => loc.f_desc8,
  "f_name9":  (loc) => loc.f_name9,
  "f_desc9":  (loc) => loc.f_desc9,
  "f_name10": (loc) => loc.f_name10,
  "f_desc10": (loc) => loc.f_desc10,
  "f_name11": (loc) => loc.f_name11,
  "f_desc11": (loc) => loc.f_desc11,
  "f_name12": (loc) => loc.f_name12,
  "f_desc12": (loc) => loc.f_desc12,
  "f_name13": (loc) => loc.f_name13,
  "f_desc13": (loc) => loc.f_desc13,
  "f_name14": (loc) => loc.f_name14,
  "f_desc14": (loc) => loc.f_desc14,
  "f_name15": (loc) => loc.f_name15,
  "f_desc15": (loc) => loc.f_desc15,
  "f_name16": (loc) => loc.f_name16,
  "f_desc16": (loc) => loc.f_desc16,
  "f_name17": (loc) => loc.f_name17,
  "f_desc17": (loc) => loc.f_desc17,
  "f_name18": (loc) => loc.f_name18,
  "f_desc18": (loc) => loc.f_desc18,
  "cat_chest": (loc) => loc.cat_chest,
  "cat_back": (loc) => loc.cat_back,
  "cat_biceps": (loc) => loc.cat_biceps,
  "cat_triceps": (loc) => loc.cat_triceps,
  "cat_forearm": (loc) => loc.cat_forearm,
  "cat_abs": (loc) => loc.cat_abs,
};

String tForce(AppLocalizations loc, String key) {
  return forceKeys[key]?.call(loc) ?? key;
}

class ForceScreen extends StatefulWidget {
  const ForceScreen({super.key});

  @override
  State<ForceScreen> createState() => _ForceScreenState();
}

class _ForceScreenState extends State<ForceScreen> {
  List<Map<String, dynamic>> allExercises = [];
  List<Map<String, dynamic>> displayedExercises = [];

  double currentProgress = 0.0;
  int userCoins = 0;
  bool _loading = true;
  late String userId;

  String selectedCategory = "";
  List<String> categories = [];


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
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      List<Map<String, dynamic>> baseExercises = [
      // 🔹 Pecho
      {
        "nameKey": "f_name1",
        "descKey": "f_desc1",
        "image": "assets/force/chest_press.png",
        "increase": 0.07,
        "category": "cat_chest",
      },
      {
        "nameKey": "f_name2",
        "descKey": "f_desc2",
        "image": "assets/force/pushups.png",
        "increase": 0.05,
        "category": "cat_chest",
      },
      {
        "nameKey": "f_name3",
        "descKey": "f_desc3",
        "image": "assets/force/dumbbell_fly.png",
        "increase": 0.06,
        "category": "cat_chest",
      },

      // 🔹 Espalda
      {
        "nameKey": "f_name4",
        "descKey": "f_desc4",
        "image": "assets/force/pullups.png",
        "increase": 0.08,
        "category": "cat_back",
      },
      {
        "nameKey": "f_name5",
        "descKey": "f_desc5",
        "image": "assets/force/barbell_row.png",
        "increase": 0.07,
        "category": "cat_back",
      },
      {
        "nameKey": "f_name6",
        "descKey": "f_desc6",
        "image": "assets/force/deadlift.png",
        "increase": 0.10,
        "category": "cat_back",
      },

      // 🔹 Bíceps
      {
        "nameKey": "f_name7",
        "descKey": "f_desc7",
        "image": "assets/force/barbell_curl.png",
        "increase": 0.06,
        "category": "cat_biceps",
      },
      {
        "nameKey": "f_name8",
        "descKey": "f_desc8",
        "image": "assets/force/dumbbell_curl.png",
        "increase": 0.05,
        "category": "cat_biceps",
      },
      {
        "nameKey": "f_name9",
        "descKey": "f_desc9",
        "image": "assets/force/hammer_curl.png",
        "increase": 0.05,
        "category": "cat_biceps",
      },

      // 🔹 Tríceps
      {
        "nameKey": "f_name10",
        "descKey": "f_desc10",
        "image": "assets/force/dips.png",
        "increase": 0.08,
        "category": "cat_triceps",
      },
      {
        "nameKey": "f_name11",
        "descKey": "f_desc11",
        "image": "assets/force/tricep_rope.png",
        "increase": 0.06,
        "category": "cat_triceps",
      },
      {
        "nameKey": "f_name12",
        "descKey": "f_desc12",
        "image": "assets/force/skullcrusher.png",
        "increase": 0.07,
        "category": "cat_triceps",
      },

      // 🔹 Antebrazo
      {
        "nameKey": "f_name13",
        "descKey": "f_desc13",
        "image": "assets/force/wrist_curl.png",
        "increase": 0.04,
        "category": "cat_forearm",
      },
      {
        "nameKey": "f_name14",
        "descKey": "f_desc14",
        "image": "assets/force/reverse_curl.png",
        "increase": 0.05,
        "category": "cat_forearm",
      },
      {
        "nameKey": "f_name15",
        "descKey": "f_desc15",
        "image": "assets/force/towel_hold.png",
        "increase": 0.05,
        "category": "cat_forearm",
      },

      // 🔹 Abdomen
      {
        "nameKey": "f_name16",
        "descKey": "f_desc16",
        "image": "assets/force/crunch.png",
        "increase": 0.04,
        "category": "cat_abs",
      },
      {
        "nameKey": "f_name17",
        "descKey": "f_desc17",
        "image": "assets/force/plank.png",
        "increase": 0.05,
        "category": "cat_abs",
      },
      {
        "nameKey": "f_name18",
        "descKey": "f_desc18",
        "image": "assets/force/leg_raise.png",
        "increase": 0.06,
        "category": "cat_abs",
      },
    ];


      if (doc.exists) {
        final data = doc.data() ?? {};
        final userExercises =
            List<Map<String, dynamic>>.from(data['forceExercises'] ?? []);
        final progress = (data['forceProgress'] ?? 0.0).toDouble();
        final coins = (data['coins'] ?? 0).toInt();

        setState(() {
          allExercises = [...baseExercises, ...userExercises];
          currentProgress = progress;
          userCoins = coins;
          _filterByCategory(selectedCategory);
          _loading = false;
        });
      } else {
        setState(() {
          allExercises = baseExercises;
          _filterByCategory(selectedCategory);
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("Error al cargar fuerza: $e");
      setState(() => _loading = false);
    }
  }

  void _filterByCategory(String translatedCategory) {
    final loc = AppLocalizations.of(context)!;

    setState(() {
      selectedCategory = translatedCategory;

      displayedExercises = allExercises.where((ex) {
        final rawCategory = ex["category"];

        // Caso 1: categoría con clave
        if (rawCategory.toString().startsWith("cat_")) {
          return tForce(loc, rawCategory) == translatedCategory;
        }

        // Caso 2: categoría personalizada (texto directo)
        return rawCategory == translatedCategory;
      }).toList();
    });
  }



  Future<void> _updateProgress(double increment) async {
    double newProgress = currentProgress + increment;
    final loc = AppLocalizations.of(context)!;
    int earnedCoins = 0;
    if (newProgress >= 1.0) {
      earnedCoins = 100;
      newProgress -= 1.0;
    }

    try {
      final newCoins = userCoins + earnedCoins;
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'forceProgress': newProgress,
        'coins': newCoins,
      });

      setState(() {
        currentProgress = newProgress;
        userCoins = newCoins;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            earnedCoins > 0
                ? loc.force_congrats
                : loc.force_improved,
          ),
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
    String selected = selectedCategory;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(loc.force_add_title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: loc.force_add_name)),
                TextField(controller: descController, decoration: InputDecoration(labelText: loc.force_add_desc)),
                DropdownButtonFormField<String>(
                  value: selected,
                  decoration: InputDecoration(labelText: loc.force_add_cat),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) => selected = value!,
                ),
                TextField(
                  controller: increaseController,
                  decoration: InputDecoration(labelText: loc.force_add_inc),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.btn_cancel)),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final desc = descController.text.trim();
                final inc = double.tryParse(increaseController.text) ?? 0.05;
                if (name.isEmpty || desc.isEmpty) return;

                final newExercise = {
                  "name": name,
                  "description": desc,
                  "image": "assets/force/custom.png",
                  "increase": inc.clamp(0.01, 0.2),
                  "category": selected,
                };

                setState(() {
                  allExercises.add(newExercise);
                  _filterByCategory(selectedCategory);
                });

                await FirebaseFirestore.instance.collection('users').doc(userId).update({
                  'forceExercises': allExercises.where((e) => e["image"] == "assets/force/custom.png").toList(),
                });

                if (context.mounted) Navigator.pop(context);
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

    categories = [
      loc.cat_chest,
      loc.cat_back,
      loc.cat_biceps,
      loc.cat_triceps,
      loc.cat_forearm,
      loc.cat_abs,
    ];

    if (selectedCategory.isEmpty) {
      selectedCategory = loc.cat_chest;
    }

    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.force_title),
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCustomExercise(context),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            // 🔹 Barra de progreso
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.force_progress,
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: currentProgress,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(8),
                        backgroundColor:
                            colorScheme.onSurface.withOpacity(0.1),
                        valueColor:
                            AlwaysStoppedAnimation(colorScheme.primary),
                      ),
                      const SizedBox(height: 6),
                      Text("${(currentProgress * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                              color: colorScheme.onBackground,
                              fontWeight: FontWeight.w600)),
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

            // 🔹 Selector de categoría
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => _filterByCategory(cat),
                      selectedColor: colorScheme.primary,
                      backgroundColor: theme.cardColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onBackground,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Lista de ejercicios SIN overflow
            ...displayedExercises.map((ex) {
              final bool isBase = ex.containsKey("nameKey");
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(ex["image"]),
                        radius: 26,
                        backgroundColor:
                            colorScheme.primary.withOpacity(0.1),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Text(
                              isBase ? tForce(loc, ex["nameKey"]) : ex["name"],
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isBase ? tForce(loc, ex["descKey"]) : ex["description"],
                              style: TextStyle(
                                color: colorScheme.onBackground.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+${(ex["increase"] * 100).toInt()}%",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          IconButton(
                            icon: const Icon(Icons.fitness_center,
                                color: Colors.redAccent, size: 24),
                            onPressed: () => _updateProgress(ex["increase"]),
                          ),
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
