import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';
import 'strength_screen.dart';
import 'nutrition_screen.dart';
import 'force_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String name = '';
  List<Map<String, dynamic>> events = [];

  bool _loading = true;
  late String userId;

  DateTime _currentWeekStart = _getStartOfWeek(DateTime.now());
  DateTime _selectedDate = DateTime.now();

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7)); // Domingo
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    userId = user.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        name = data['name'] ?? '';
        events = List<Map<String, dynamic>>.from(data['events'] ?? []);
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  /// 🗓️ Filtrar eventos del día seleccionado
  List<Map<String, dynamic>> get _filteredEvents {
    final selected = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
    return events.where((e) => e['date'] == selected).toList();
  }

  /// 🗓️ Agregar nuevo evento
  Future<void> _addEvent(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final descController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(loc.planEvent),
          content: StatefulBuilder(builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: loc.eventDescription),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedDate == null
                        ? loc.selectDate
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedTime == null
                        ? loc.selectTime
                        : selectedTime!.format(context)),
                    IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setModalState(() => selectedTime = picked);
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                if (descController.text.trim().isEmpty ||
                    selectedDate == null ||
                    selectedTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(loc.completeAllFields),
                        backgroundColor: Colors.orangeAccent),
                  );
                  return;
                }

                final newEvent = {
                  'description': descController.text.trim(),
                  'date':
                      "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
                  'time': selectedTime!.format(context),
                };

                setState(() {
                  events.add(newEvent);
                });

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({'events': events});

                if (mounted) Navigator.pop(context);
              },
              child: Text(loc.save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEvent(int index) async {
    setState(() => events.removeAt(index));
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'events': events});
  }

  /// 🔹 Cambio de semana
  void _changeWeek(bool next) {
    setState(() {
      _currentWeekStart = next
          ? _currentWeekStart.add(const Duration(days: 7))
          : _currentWeekStart.subtract(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: colorScheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: colorScheme.primary.withOpacity(0.1),
        title: Text(loc.progress,
            style: TextStyle(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _addEvent(context),
            tooltip: loc.addEvent,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${loc.hello} $name,",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Tarjetas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCard(loc.resistance, Icons.directions_run, Colors.orangeAccent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StrengthScreen()));
                }),
                _buildCard(loc.nutrition, Icons.restaurant, Colors.redAccent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionScreen()));
                }),
                _buildCard(loc.force, Icons.fitness_center, Colors.blueAccent, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ForceScreen()));
                }),
              ],
            ),
            const SizedBox(height: 25),

            // 🔹 Calendario semanal deslizable
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeWeek(false),
                ),
                Text(
                  "${_currentWeekStart.day}/${_currentWeekStart.month} - ${_currentWeekStart.add(const Duration(days: 6)).day}/${_currentWeekStart.month}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeWeek(true),
                ),
              ],
            ),
            _buildWeekCalendar(colorScheme),
            const SizedBox(height: 30),

            // 🔹 Eventos del día
            _filteredEvents.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        loc.noEventsYet,
                        style: TextStyle(
                            color: colorScheme.onBackground.withOpacity(0.7),
                            fontSize: 16),
                      ),
                    ),
                  )
                : Column(
                    children: List.generate(_filteredEvents.length, (i) {
                      final e = _filteredEvents[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading:
                              const Icon(Icons.event, color: Colors.deepPurple),
                          title: Text(e['description']),
                          subtitle: Text("${e['date']} • ${e['time']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteEvent(
                                events.indexOf(e)), // elimina del total
                          ),
                        ),
                      );
                    }),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground)),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Calendario semanal vinculado a la fecha real
  Widget _buildWeekCalendar(ColorScheme colorScheme) {
    final days = ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sá"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final dayDate = _currentWeekStart.add(Duration(days: index));
        final isSelected = dayDate.year == _selectedDate.year &&
            dayDate.month == _selectedDate.month &&
            dayDate.day == _selectedDate.day;

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = dayDate),
          child: Column(
            children: [
              Text(days[index],
                  style: TextStyle(
                    color: colorScheme.onBackground.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(height: 6),
              Container(
                width: 35,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${dayDate.day}",
                  style: TextStyle(
                    color: isSelected ? Colors.white : colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
