import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool loading = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data();
        });

        messages.insert(0, {
          'role': 'bot',
          'text':
              '¡Hola ${userData?['name']}! 👋 Soy ZyntraCoach, tu entrenador virtual. Estoy listo para ayudarte con tus rutinas y nutrición.'
        });
      }
    } catch (e) {
      debugPrint("Error cargando usuario: $e");
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || userData == null) return;

    setState(() {
      messages.insert(0, {'role': 'user', 'text': text});
      loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://zyntra-backend-oetw.onrender.com/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "message": text,
          "user": {
            "nombre": userData!['name'],
            "edad": userData!['age'],
            "altura": userData!['height'],
            "peso": userData!['weight'],
            "nivel": userData!['level'],
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          messages.insert(0, {'role': 'bot', 'text': data['reply']});
        });
      } else {
        setState(() {
          messages.insert(0, {
            'role': 'bot',
            'text':
                '❌ Error ${response.statusCode}: No se pudo conectar con el servidor.'
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.insert(0, {'role': 'bot', 'text': '⚠️ Error: $e'});
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZyntraCoach 💪'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final m = messages[i];
                      final isUser = m['role'] == 'user';
                      return Container(
                        padding: const EdgeInsets.all(8),
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.deepPurpleAccent
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            m['text']!,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (loading) const LinearProgressIndicator(),
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText:
                                'Escribe tu pregunta sobre entrenamiento o dieta...',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onSubmitted: (value) {
                            final text = _controller.text;
                            _controller.clear();
                            sendMessage(text);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send,
                            color: Colors.deepPurpleAccent),
                        onPressed: () {
                          final text = _controller.text;
                          _controller.clear();
                          sendMessage(text);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
