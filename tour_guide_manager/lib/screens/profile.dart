import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Профиль',
          style: TextStyle(fontWeight: FontWeight.w600),
          ),
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
        title: const Text('Профиль',
        style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xffE6F2FF),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xffE6F2FF),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('guides')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/empty_profile.svg',
                        width: 300,
                        height: 300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Тут пока ничего нет',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    'Информация появится, когда админ добавит её',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text('Выйти из аккаунта', style: TextStyle(color: Color(
                          0xff005BFF)),),
                    ),
                  ),
                ],
              ),
            );
          }
          // Safe cast with null check
          final doc = snapshot.data!.docs.first;
          final userData = doc.data() as Map<String, dynamic>;
          final user = UserProfile.fromFirestore(userData);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/avatar.svg',
                      width: 150,
                      height: 150,
                    ),
                  ],
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
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '@${user.telegramAlias}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Divider(),
                      Text(
                        'Экскурсий проведено: ${user.excursionsDone}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Divider(),
                      Text(
                        '${user.phone}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      'Выйти из аккаунта',
                      style: TextStyle(color: Color(0xff005BFF))),
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
  final int excursionsDone;
  final String telegramAlias;
  final String phone;

  UserProfile({
    required this.name,
    required this.excursionsDone,
    required this.telegramAlias,
    required this.phone
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name']?.toString() ?? 'Имя не указано',
      excursionsDone: (data['excursionsDone'] as int?) ?? 0,
      telegramAlias: data['telegramAlias']?.toString() ?? 'Telegram не указан',
      phone: data['phone']?.toString() ?? 'Номер телефона не указан'
    );
  }
}
