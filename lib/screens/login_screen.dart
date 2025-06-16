import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showError('Введите email и пароль');
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showError('Пользователь не найден');
      } else if (e.code == 'wrong-password') {
        _showError('Неверный пароль');
      } else {
        _showError('Ошибка входа: ${e.message}');
      }
    } catch (e) {
      _showError('Неизвестная ошибка: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _sendPasswordResetEmail(String userEmail) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
      _showError('Письмо отправлено на почту');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Некорректный email адрес';
          _showError(errorMessage);
          break;
        case 'user-not-found':
          errorMessage = 'Пользователь с таким email не найден';
          _showError(errorMessage);
          break;
        default:
          errorMessage = 'Произошла ошибка: ${e.message}';
          _showError(errorMessage);
      }
    }
  }

  void showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xffE6F2FF),
        title: Text(
          'Забыли пароль?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xff333333),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Введите email для восстановления доступа',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена', style: TextStyle(color: Color(0xff005BFF))),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Color(0xff005BFF),
            ),
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                _sendPasswordResetEmail(emailController.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Отправить'),
          ),
        ],
      ),
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
              'Войдите в аккаунт',
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
              width: double.infinity,
              child: FilledButton(
                onPressed: _signIn,
                style: FilledButton.styleFrom(
                    backgroundColor: Color(0xff005BFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                child: Text(
                  'Войти',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Нет аккаунта?'),
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
                            MaterialPageRoute(builder: (context) => RegistrationScreen())
                          );
                        },
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                            color: Color(0xff005BFF),
                          ),
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 3),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showForgotPasswordDialog(context);
                    },
                    child: Text(
                      'Забыли пароль?',
                      style: TextStyle(
                        color: Color(0xff005BFF),
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
