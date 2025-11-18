import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final user = FirebaseAuth.instance.currentUser;

  /// 🔹 Devuelve la imagen del avatar según el nivel del usuario
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

  /// 🔹 Eliminar un amigo (recíproco)
  Future<void> _removeFriend(String friendUid) async {
    if (user == null) return;

    final uid = user!.uid;

    try {
      final currentRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      final friendRef =
          FirebaseFirestore.instance.collection('users').doc(friendUid);

      await currentRef.update({
        "friends": FieldValue.arrayRemove([friendUid])
      });

      await friendRef.update({
        "friends": FieldValue.arrayRemove([uid])
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Amigo eliminado")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.yourFriends),
        centerTitle: true,
        backgroundColor: colorScheme.primary.withOpacity(0.2),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> friends = data["friends"] ?? [];

          if (friends.isEmpty) {
            return Center(
              child: Text(
                loc.noFriendsYet,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("users")
                .where(FieldPath.documentId, whereIn: friends)
                .get(),
            builder: (context, friendsSnapshot) {
              if (!friendsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = friendsSnapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final friendData = docs[index].data() as Map<String, dynamic>;
                  final friendUid = docs[index].id;

                  final name = friendData["name"] ?? "Usuario";
                  final age = friendData["age"]?.toString() ?? "-";
                  final level = friendData["level"] ?? "recluta";

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
                      title: Text(name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${loc.age}: $age"),
                      trailing: ElevatedButton(
                        onPressed: () => _removeFriend(friendUid),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(loc.removeFriend),
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
