import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:needai/core/themes/colors.dart';
import 'package:needai/features/teachers/presentation/teacherchatpage.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({super.key});

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.people_alt_rounded),
        title: Text('Наши эксперты', style: TextStyle(color: lighttext)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('SAT'),
                    selected: _selectedFilter == 'SAT',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? 'SAT' : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('TOEFL'),
                    selected: _selectedFilter == 'TOEFL',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? 'TOEFL' : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Эссе'),
                    selected: _selectedFilter == 'Эссе',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? 'Эссе' : null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Виза'),
                    selected: _selectedFilter == 'Виза',
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = selected ? 'Виза' : null;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users_teachers').snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Ошибка загрузки данных'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final teachers = snapshot.data!.docs;

                  if (teachers.isEmpty) {
                    return const Center(
                      child: Text('Преподаватели не найдены'),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      final teacher =
                          teachers[index].data() as Map<String, dynamic>;
                      final TeacherId = teachers[index].id;
                      return Column(
                        children: [
                          TeacherCard(
                            teacherId: TeacherId,
                            name: teacher['firstName'] ?? 'Без имени',
                            description: teacher['desc'] ?? '',
                            experience: teacher['exp'] ?? '0 лет',

                            skills: teacher['skills'] ?? 'Нет навыков',
                          ),
                        ],
                      );
                    },
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

class TeacherCard extends StatefulWidget {
  final String teacherId;
  final String name;
  final String description;
  final String experience;
  final String skills;

  const TeacherCard({
    required this.teacherId,
    required this.skills,
    required this.experience,
    super.key,
    required this.name,
    required this.description,
  });

  @override
  State<TeacherCard> createState() => _TeacherCardState();
}

class _TeacherCardState extends State<TeacherCard> {
  String getChatId(String userA, String userB) {
    final ids = [userA, userB]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> _sendMessage(BuildContext context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Пожалуйста, войдите в систему')));
      return;
    }

    final chatId = getChatId(auth.currentUser!.uid, widget.teacherId);

    try {
      await firestore.collection('chats').doc(chatId).set({
        'participants': [auth.currentUser!.uid, widget.teacherId],
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
            'senderId': auth.currentUser!.uid,
            'message': 'Привет, ${widget.name}!',
            'timestamp': FieldValue.serverTimestamp(),
            'text' : 'Привет, ${widget.name}!',
          });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherChatPage(otherUserId: widget.teacherId),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Сообщение отправлено ${widget.name}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка отправки сообщения: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Выбрали ${widget.name}')));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                'https://tinyurl.com/mry8z4h6',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    width: double.infinity,
                    child: Icon(
                      CupertinoIcons.profile_circled,
                      color: Colors.black,
                      size: 150,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.experience,
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Hero(
                    tag: "persik",
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          await _sendMessage(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          child: const Text('Написать'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
