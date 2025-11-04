import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String selectedCategory = "Pecho";

  final List<String> categories = [
    "Pecho",
    "Espalda",
    "Bíceps",
    "Tríceps",
    "Antebrazo",
    "Abdomen",
  ];

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
        {
          "name": "Press de banca",
          "description": "Ejercicio clásico para desarrollar el pecho.",
          "image": "assets/force/chest_press.png",
          "increase": 0.07,
          "category": "Pecho"
        },
        {
          "name": "Flexiones",
          "description":
              "Ejercicio con peso corporal para fuerza y resistencia.",
          "image": "assets/force/pushups.png",
          "increase": 0.05,
          "category": "Pecho"
        },
        {
          "name": "Aperturas con mancuernas",
          "description": "Trabaja los pectorales mayores con amplitud.",
          "image": "assets/force/dumbbell_fly.png",
          "increase": 0.06,
          "category": "Pecho"
        },
        {
          "name": "Dominadas",
          "description": "Fortalece la espalda y los bíceps.",
          "image": "assets/force/pullups.png",
          "increase": 0.08,
          "category": "Espalda"
        },
        {
          "name": "Remo con barra",
          "description": "Desarrolla la parte media de la espalda.",
          "image": "assets/force/barbell_row.png",
          "increase": 0.07,
          "category": "Espalda"
        },
        {
          "name": "Peso muerto",
          "description": "Ejercicio compuesto que involucra toda la espalda.",
          "image": "assets/force/deadlift.png",
          "increase": 0.10,
          "category": "Espalda"
        },
        {
          "name": "Curl con barra",
          "description": "Aumenta el tamaño y fuerza de los bíceps.",
          "image": "assets/force/barbell_curl.png",
          "increase": 0.06,
          "category": "Bíceps"
        },
        {
          "name": "Curl con mancuernas",
          "description": "Permite un movimiento más natural y controlado.",
          "image": "assets/force/dumbbell_curl.png",
          "increase": 0.05,
          "category": "Bíceps"
        },
        {
          "name": "Martillo",
          "description": "Trabaja el braquial y el antebrazo.",
          "image": "assets/force/hammer_curl.png",
          "increase": 0.05,
          "category": "Bíceps"
        },
        {
          "name": "Fondos en paralelas",
          "description": "Ejercicio exigente para tríceps y pecho.",
          "image": "assets/force/dips.png",
          "increase": 0.08,
          "category": "Tríceps"
        },
        {
          "name": "Extensiones con cuerda",
          "description": "Ideal para definir los tríceps.",
          "image": "assets/force/tricep_rope.png",
          "increase": 0.06,
          "category": "Tríceps"
        },
        {
          "name": "Press francés",
          "description": "Enfoca el trabajo en el tríceps largo.",
          "image": "assets/force/skullcrusher.png",
          "increase": 0.07,
          "category": "Tríceps"
        },
        {
          "name": "Curl de muñeca",
          "description": "Fortalece los músculos flexores del antebrazo.",
          "image": "assets/force/wrist_curl.png",
          "increase": 0.04,
          "category": "Antebrazo"
        },
        {
          "name": "Curl inverso",
          "description":
              "Trabaja extensores y parte superior del antebrazo.",
          "image": "assets/force/reverse_curl.png",
          "increase": 0.05,
          "category": "Antebrazo"
        },
        {
          "name": "Toalla hold",
          "description": "Desarrolla la fuerza de agarre.",
          "image": "assets/force/towel_hold.png",
          "increase": 0.05,
          "category": "Antebrazo"
        },
        {
          "name": "Abdominales crunch",
          "description":
              "Ejercicio básico para la parte superior del abdomen.",
          "image": "assets/force/crunch.png",
          "increase": 0.04,
          "category": "Abdomen"
        },
        {
          "name": "Plancha",
          "description": "Fortalece todo el core.",
          "image": "assets/force/plank.png",
          "increase": 0.05,
          "category": "Abdomen"
        },
        {
          "name": "Elevaciones de piernas",
          "description": "Trabaja el abdomen inferior y la estabilidad.",
          "image": "assets/force/leg_raise.png",
          "increase": 0.06,
          "category": "Abdomen"
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

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      displayedExercises =
          allExercises.where((e) => e["category"] == category).toList();
    });
  }

  Future<void> _updateProgress(double increment) async {
    double newProgress = currentProgress + increment;
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
                ? "🏋️‍♂️ ¡Increíble! Has ganado 100 puntos."
                : "💪 ¡Excelente! Tu fuerza ha aumentado.",
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
    String selected = selectedCategory;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Agregar nuevo ejercicio"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nombre del ejercicio")),
                TextField(controller: descController, decoration: const InputDecoration(labelText: "Descripción")),
                DropdownButtonFormField<String>(
                  value: selected,
                  decoration: const InputDecoration(labelText: "Categoría muscular"),
                  items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) => selected = value!,
                ),
                TextField(
                  controller: increaseController,
                  decoration: const InputDecoration(labelText: "Aumento de progreso (0.01 - 0.2)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
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
              child: const Text("Agregar"),
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

    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Entrenamiento de Fuerza"),
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
                      Text("Progreso de Fuerza",
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
                      Text("Monedas: $userCoins 🪙",
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
                            Text(ex["name"],
                                style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(
                              ex["description"],
                              style: TextStyle(
                                color: colorScheme.onBackground
                                    .withOpacity(0.8),
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
