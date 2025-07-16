import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_manager/colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser!.email!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('guides')
            .where('email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue)
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/error.svg',
                    height: MediaQuery.of(context).size.height * 0.27,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ошибка загрузки',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 16
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    SvgPicture.asset(
                      'assets/empty_profile.svg',
                      height: MediaQuery.of(context).size.height * 0.285,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Тут пока ничего нет',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'Информация появится, когда админ добавит её',
                      style: const TextStyle(fontSize: 17, color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: const Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final doc = snapshot.data!.docs.first;
          final userData = doc.data() as Map<String, dynamic>;
          final user = UserProfile.fromFirestore(userData);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/avatar.svg',
                  height: MediaQuery.of(context).size.height * 0.17,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.grey
                  ),
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;
                    final double cardWidth = isWide ? 560.0 : double.infinity;

                    return Center(
                      child: Container(
                        width: cardWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Уровень: ${user.level}',
                              style: const TextStyle(fontSize: 17, color: AppColors.grey),
                            ),
                            const Divider(),
                            Text(
                              'Экскурсий проведено: ${user.excursionsDone}',
                              style: const TextStyle(fontSize: 17, color: AppColors.grey),
                            ),
                            const Divider(),
                            Text(
                              '${user.phone}',
                              style: const TextStyle(fontSize: 17, color: AppColors.grey),
                            ),
                            const Divider(),
                            Text(
                              user.telegramAlias.contains('@') ? user.telegramAlias : '@${user.telegramAlias}',
                              style: const TextStyle(fontSize: 17, color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text(
                      'Выйти из аккаунта',
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                      ),
                    ),
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
  final String level;

  UserProfile({
    required this.name,
    required this.excursionsDone,
    required this.telegramAlias,
    required this.phone,
    required this.level
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name'] ?? 'Имя не указано',
      excursionsDone: (data['toursCount'] as int?) ?? 0,
      telegramAlias: data['telegramAlias'] ?? 'Telegram не указан',
      phone: data['phone']?.toString() ?? 'Номер телефона не указан',
      level: data['level'] ?? 'Уровень не указан'
    );
  }
}
