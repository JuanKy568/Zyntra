import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  List<Map<String, dynamic>> diets = [
    {
      "name": "Dieta balanceada",
      "description":
          "Incluye frutas, verduras, proteínas magras y granos integrales. Ideal para mantener energía.",
      "image": "assets/nutrition/balanced.png",
      "increase": 0.07
    },
    {
      "name": "Alta en proteínas",
      "description":
          "Basada en carnes magras, legumbres y huevos. Ideal para desarrollo muscular.",
      "image": "assets/nutrition/protein.png",
      "increase": 0.08
    },
    {
      "name": "Vegana saludable",
      "description":
          "Enfocada en alimentos vegetales ricos en fibra y antioxidantes.",
      "image": "assets/nutrition/vegan.png",
      "increase": 0.06
    },
    {
      "name": "Definición y bajo en calorías",
      "description":
          "Diseñada para reducir grasa corporal manteniendo masa muscular.",
      "image": "assets/nutrition/lowcal.png",
      "increase": 0.09
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
    await _loadProgressAndDiets();
  }

  /// 🔹 Cargar progreso, dietas y monedas
  Future<void> _loadProgressAndDiets() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (doc.exists) {
        final data = doc.data() ?? {};
        final userDiets =
            List<Map<String, dynamic>>.from(data['nutritionPlans'] ?? []);
        final progress = (data['nutritionProgress'] ?? 0.0).toDouble();
        final coins = (data['coins'] ?? 0).toInt();

        setState(() {
          diets = [...diets, ...userDiets];
          currentProgress = progress;
          userCoins = coins;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint("Error al cargar progreso o dietas: $e");
      setState(() => _loading = false);
    }
  }

  /// 🔹 Guardar dietas personalizadas en Firestore
  Future<void> _saveDietsToFirestore() async {
    try {
      final customDiets =
          diets.where((d) => d["image"] == "assets/nutrition/custom.png").toList();

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'nutritionPlans': customDiets,
      });
    } catch (e) {
      debugPrint("Error al guardar dietas: $e");
    }
  }

  /// 🔹 Actualizar progreso con bonificación
  Future<void> _updateProgress(double increment) async {
    double newProgress = currentProgress + increment;
    int earnedCoins = 0;

    // 🎯 Si llega o supera 100%
    if (newProgress >= 1.0) {
      earnedCoins = 100;
      newProgress = newProgress - 1.0;
    }

    try {
      final newCoins = userCoins + earnedCoins;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'nutritionProgress': newProgress,
        'coins': newCoins,
      });

      setState(() {
        currentProgress = newProgress;
        userCoins = newCoins;
      });

      if (earnedCoins > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("🎉 ¡Felicidades! Has ganado 100 puntos por tu progreso nutricional."),
            backgroundColor: Colors.amber.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🥗 ¡Excelente! Tu progreso nutricional ha mejorado."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("Error al actualizar progreso: $e");
    }
  }

  /// 🔹 Agregar dieta personalizada
  Future<void> _addCustomDiet(BuildContext context) async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final increaseController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Agregar nueva dieta"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nombre de la dieta"),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: "Descripción"),
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
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final desc = descController.text.trim();
                final inc = double.tryParse(increaseController.text) ?? 0.05;

                if (name.isEmpty || desc.isEmpty) return;

                final newDiet = {
                  "name": name,
                  "description": desc,
                  "image": "assets/nutrition/custom.png",
                  "increase": inc.clamp(0.01, 0.2),
                };

                setState(() {
                  diets.add(newDiet);
                });

                await _saveDietsToFirestore();
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
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        title: const Text("Planes de Nutrición"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCustomDiet(context),
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Barra de progreso y monedas
            Card(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Progreso Nutricional",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: currentProgress,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${(currentProgress * 100).toStringAsFixed(1)}%",
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Monedas: $userCoins 🪙",
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Lista de dietas
            Expanded(
              child: ListView.builder(
                itemCount: diets.length,
                itemBuilder: (context, index) {
                  final diet = diets[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(diet["image"]),
                        radius: 28,
                        backgroundColor: colorScheme.primary.withOpacity(0.1),
                      ),
                      title: Text(
                        diet["name"],
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          diet["description"],
                          style: TextStyle(
                            color: colorScheme.onBackground.withOpacity(0.8),
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "+${(diet["increase"] * 100).toInt()}%",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Flexible(
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.restaurant_menu,
                                color: Colors.orangeAccent,
                                size: 26,
                              ),
                              onPressed: () => _updateProgress(diet["increase"]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
