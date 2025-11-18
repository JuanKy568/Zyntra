import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/app_localizations.dart';

class FriendNotificationsScreen extends StatefulWidget {
  const FriendNotificationsScreen({super.key});

  @override
  State<FriendNotificationsScreen> createState() => _FriendNotificationsScreenState();
}

class _FriendNotificationsScreenState extends State<FriendNotificationsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  /// 🔹 Aceptar solicitud
  Future<void> _acceptRequest(String senderUid) async {
    final loc = AppLocalizations.of(context)!;
    if (user == null) return;
    final currentUid = user!.uid;

    final currentRef = FirebaseFirestore.instance.collection("users").doc(currentUid);
    final senderRef = FirebaseFirestore.instance.collection("users").doc(senderUid);

    try {
      await currentRef.update({
        "friendRequestsReceived": FieldValue.arrayRemove([senderUid]),
        "friends": FieldValue.arrayUnion([senderUid])
      });

      await senderRef.update({
        "friendRequestsSent": FieldValue.arrayRemove([currentUid]),
        "friends": FieldValue.arrayUnion([currentUid])
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(loc.six)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// 🔹 Rechazar solicitud
  Future<void> _rejectRequest(String senderUid) async {
    final loc = AppLocalizations.of(context)!;
    if (user == null) return;
    final currentUid = user!.uid;

    final currentRef = FirebaseFirestore.instance.collection("users").doc(currentUid);
    final senderRef = FirebaseFirestore.instance.collection("users").doc(senderUid);

    try {
      await currentRef.update({
        "friendRequestsReceived": FieldValue.arrayRemove([senderUid])
      });

      await senderRef.update({
        "friendRequestsSent": FieldValue.arrayRemove([currentUid])
      });

      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(loc.sev)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// 🔹 Obtener avatar como imagen
  String _avatarImage(String level) {
    switch (level.toLowerCase()) {
      case 'cadet':
      case 'cadete':
        return "assets/avatars/cadete.png";
      case 'warrior':
      case 'guerrero':
        return "assets/avatars/guerrero.png";
      case 'gladiador':
      case 'gladiator':
        return "assets/avatars/gladiador.png";
      case 'elite':
      case 'élite':
        return "assets/avatars/elite.png";
      case 'master':
      case 'maestro':
        return "assets/avatars/maestro.png";
      case 'titan':
      case 'titán':
        return "assets/avatars/titan.png";
      case 'legend':
      case 'leyenda':
        return "assets/avatars/leyenda.png";

      /// VIPs
      case 'vip1':
        return "assets/avatars/vip1.png";
      case 'vip2':
        return "assets/avatars/vip2.png";
      case 'vip3':
        return "assets/avatars/vip3.png";

      default:
        return "assets/avatars/recluta.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tres),
        backgroundColor: colorScheme.primary.withOpacity(0.2),
        elevation: 2,
        centerTitle: true,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection("users").doc(user!.uid).get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snap.data!.data() as Map<String, dynamic>;
          final List received = data["friendRequestsReceived"] ?? [];

          if (received.isEmpty) {
            return Center(
              child: Text(
                loc.cua,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: received.length,
            itemBuilder: (context, index) {
              final senderUid = received[index];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection("users").doc(senderUid).get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData) return Container();

                  final uData = userSnap.data!.data() as Map<String, dynamic>;
                  final name = uData["name"] ?? "Usuario";
                  final age = uData["age"]?.toString() ?? "-";
                  final level = uData["level"]?.toString() ?? "recluta";

                  final avatar = _avatarImage(level);

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage(avatar),
                      ),
                      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Edad: $age"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            tooltip: "Aceptar",
                            onPressed: () => _acceptRequest(senderUid),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: "Rechazar",
                            onPressed: () => _rejectRequest(senderUid),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
