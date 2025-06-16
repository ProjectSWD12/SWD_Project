import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final telegramController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showError('Введите email и пароль');
        return;
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate())
        );
      }

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showError('Этот email уже используется');
      } else if (e.code == 'weak-password') {
        _showError('Пароль слишком простой');
      } else if (e.code == 'invalid-email') {
        _showError('Неверный формат email');
      } else {
        _showError('Ошибка регистрации: ${e.message}');
      }
    }
  }

  Future<void> writeData(String tg, String name) async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          'telegram': tg,
          'excursionsDone': 0,
          'name': name,
      });
    } on FirebaseException catch (e) {
      _showError('Произошла ошибка: ${e.message}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6F2FF),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Создайте аккаунт',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: TextField(
                controller: emailController,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Color(0xff5A5A5A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  hintText: 'Пароль',
                  hintStyle: TextStyle(color: Color(0xff5A5A5A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: TextField(
                controller: nameController,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  hintText: 'Имя и фамилия',
                  hintStyle: TextStyle(color: Color(0xff5A5A5A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: TextField(
                controller: telegramController,
                style: TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  hintText: 'Telegram',
                  hintStyle: TextStyle(color: Color(0xff5A5A5A)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  _signUp();
                  writeData(telegramController.text, nameController.text);
                },
                style: FilledButton.styleFrom(
                    backgroundColor: Color(0xff005BFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: Text(
                  'Регистрация',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Уже есть аккаунт?'),
                  SizedBox(width: 6),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                    child: Text(
                      'Вход',
                      style: TextStyle(
                        color: Color(0xff005BFF),
                      ),
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


