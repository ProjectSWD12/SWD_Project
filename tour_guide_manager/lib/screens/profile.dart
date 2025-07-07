import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          backgroundColor: const Color(0xffE6F2FF),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xffE6F2FF),
        body: const Center(child: Text('Пользователь не авторизован')),
      );
    }

    final email = currentUser.email ?? 'Email не указан';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: const Color(0xffE6F2FF),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffE6F2FF),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }


          if (!snapshot.hasData ||
              !snapshot.data!.exists ||
              snapshot.data!.data() == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: const Color(0xffFFFDFD),
                    radius: 60,
                    child: const Icon(
                      Icons.person_rounded,
                      size: 92,
                      color: Color(0x88070303),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Пользователь',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Экскурсий проведено: 0',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text('Выйти из аккаунта', style: TextStyle(color: Color(0xffbf0404)),),
                    ),
                  ),
                ],
              ),
            );
          }
          // Safe cast with null check
          final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
          final user = UserProfile.fromFirestore(userData);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                CircleAvatar(
                  backgroundColor: const Color(0xffFFFDFD),
                  radius: 60,
                  child: const Icon(Icons.person_rounded, size: 92, color: Color(0x88070303),),
                ),
                const SizedBox(height: 20),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  email,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Экскурсий проведено: ${user.excursionsDone}',
                  style: const TextStyle(fontSize: 18),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      'Выйти из аккаунта',
                      style: TextStyle(color: Color(0xffbf0404))),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class UserProfile {
  final String name;
  final int excursionsDone; // Changed to int

  UserProfile({
    required this.name,
    required this.excursionsDone,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name']?.toString() ?? 'Имя не указано',
      excursionsDone: (data['excursionsDone'] as int?) ?? 0,
    );
  }
}