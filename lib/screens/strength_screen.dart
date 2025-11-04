import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StrengthScreen extends StatefulWidget {
  const StrengthScreen({super.key});

  @override
  State<StrengthScreen> createState() => _StrengthScreenState();
}

class _StrengthScreenState extends State<StrengthScreen> {
  List<Map<String, dynamic>> exercises = [
    {
      "name": "Caminata intensa",
      "description": "Camina a paso rápido durante 30 minutos.",
      "image": "assets/exercises/walk.png",
      "increase": 0.05
    },
    {
      "name": "Saltar la cuerda",
      "description": "Realiza 3 sesiones de 2 minutos de salto.",
      "image": "assets/exercises/jump_rope.png",
      "increase": 0.08
    },
    {
      "name": "Ciclismo",
      "description": "Andar en bicicleta durante 40 minutos a ritmo moderado.",
      "image": "assets/exercises/cycling.png",
      "increase": 0.10
    },
    {
      "name": "Subir escaleras",
      "description": "Sube escaleras por 10 minutos sin parar.",
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
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

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

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'strengthExercises': customExercises,
      });
    } catch (e) {
      debugPrint("Error al guardar ejercicios: $e");
    }
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
            earnedCoins > 0
                ? "🏆 ¡Felicidades! Has ganado 100 puntos."
                : "🔥 ¡Excelente! Tu resistencia ha aumentado.",
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

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Agregar nuevo ejercicio"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Nombre del ejercicio"),
                ),
                TextField(
                  controller: descController,
                  decoration:
                      const InputDecoration(labelText: "Descripción"),
                ),
                TextField(
                  controller: increaseController,
                  decoration: const InputDecoration(
                      labelText: "Aumento de progreso (0.01 - 0.2)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final desc = descController.text.trim();
                final inc = double.tryParse(increaseController.text) ?? 0.05;

                if (name.isEmpty || desc.isEmpty) return;

                final newExercise = {
                  "name": name,
                  "description": desc,
                  "image": "assets/exercises/custom.png",
                  "increase": inc.clamp(0.01, 0.2),
                };

                setState(() {
                  exercises.add(newExercise);
                });

                await _saveExercisesToFirestore();
                Navigator.pop(context);
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
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        title: const Text("Entrenamiento de Resistencia"),
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
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Progreso de Resistencia",
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
                      Text("Monedaz: $userCoins 🪙",
                          style: TextStyle(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 Lista de ejercicios sin overflow
            ...exercises.map((item) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(item["image"]),
                        radius: 28,
                        backgroundColor:
                            colorScheme.primary.withOpacity(0.1),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["description"],
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
                            "+${(item["increase"] * 100).toInt()}%",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill,
                                color: Colors.blueAccent, size: 28),
                            onPressed: () => _updateProgress(item["increase"]),
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
