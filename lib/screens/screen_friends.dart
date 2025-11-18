import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';

// IMPORTAMOS LOS SCREENS DIRECTAMENTE (sin rutas en main)
import 'screen_yourfriends.dart';
import 'screen_notification.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  /// 🔹 Envía solicitud de amistad
  Future<void> _sendFriendRequest(String targetUid) async {
    final loc = AppLocalizations.of(context)!;
    if (user == null || targetUid == user!.uid) return;

    final currentUid = user!.uid;
    final userRef = FirebaseFirestore.instance.collection("users").doc(currentUid);
    final targetRef = FirebaseFirestore.instance.collection("users").doc(targetUid);

    try {
      await userRef.update({
        "friendRequestsSent": FieldValue.arrayUnion([targetUid])
      });

      await targetRef.update({
        "friendRequestsReceived": FieldValue.arrayUnion([currentUid])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.requestSent)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${loc.error}: $e")),
      );
    }
  }

  /// 🔹 Devuelve ruta del avatar en imagen estática
  String _avatarImage(String level) {
    switch (level.toLowerCase()) {
      case 'cadet':
      case 'cadete':
        return "assets/avatars/cadete.png";
      case 'warrior':
      case 'guerrero':
        return "assets/avatars/guerrero.png";
      case 'gladiator':
      case 'gladiador':
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

      /// 🟡 VIP
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
        title: Text(loc.users),
        centerTitle: true,
        backgroundColor: colorScheme.primary.withOpacity(0.2),
        elevation: 2,
        actions: [
          // 🔹 Botón de tus amigos
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: loc.yourFriends,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const YourFriendsScreen()),
              );
            },
          ),
          // 🔹 Botón de solicitudes
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: loc.requests,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FriendNotificationsScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs
              .where((d) => d.id != user!.uid) // Excluirte a ti mismo
              .toList();

          if (docs.isEmpty) {
            return Center(child: Text(loc.noUsersAvailable));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              final uid = docs[index].id;

              final name = data["name"] ?? "";
              final age = data["age"]?.toString() ?? "-";
              final level = data["level"]?.toString() ?? "recluta";

              final avatar = _avatarImage(level);

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage(avatar),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${loc.age}: $age"),
                  trailing: ElevatedButton(
                    onPressed: () => _sendFriendRequest(uid),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(loc.btn_add),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
