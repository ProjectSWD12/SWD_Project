import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide_manager/colors.dart';
import 'package:tour_guide_manager/widgets/top_snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showTopSnackBar(context, 'Введите email и пароль');
        setState(() {
          isLoading = false;
        });
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'user-not-found') {
        showTopSnackBar(context, 'Пользователь не найден');
      } else if (e.code == 'wrong-password') {
        showTopSnackBar(context, 'Неверный пароль');
      } else {
        showTopSnackBar(context, 'Ошибка входа: ${e.message}');
      }
    } catch (e) {
      if (!mounted) return;
      showTopSnackBar(context, 'Неизвестная ошибка: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendPasswordResetEmail(String userEmail) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
      if (!mounted) return;
      showTopSnackBar(context, 'Письмо отправлено на почту');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Некорректный email адрес';
          showTopSnackBar(context, errorMessage);
          break;
        case 'user-not-found':
          errorMessage = 'Пользователь с таким email не найден';
          showTopSnackBar(context, errorMessage);
          break;
        default:
          errorMessage = 'Произошла ошибка: ${e.message}';
          showTopSnackBar(context, errorMessage);
      }
    }
  }

  void showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Забыли пароль?',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.darkGrey,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Введите email для восстановления доступа',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff333333),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: TextField(
                controller: emailController,
                cursorColor: AppColors.darkBlue,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: AppColors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12
                  ),
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
            child: const Text(
              'Отмена',
              style: TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w500
              )
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
            ),
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                _sendPasswordResetEmail(emailController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Отправить',
              style: TextStyle(fontWeight: FontWeight.w500)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(color: AppColors.darkBlue)
      ) :
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Войдите в аккаунт',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: AppColors.darkGrey,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: TextField(
                controller: emailController,
                cursorColor: AppColors.darkBlue,
                style: const TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12
                  ),
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: AppColors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: TextField(
                controller: passwordController,
                cursorColor: AppColors.darkBlue,
                obscureText: true,
                style: const TextStyle(fontSize: 17),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12
                  ),
                  hintText: 'Пароль',
                  hintStyle: const TextStyle(color: AppColors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: FilledButton(
                onPressed: _signIn,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                ),
                child: const Text(
                  'Войти',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Нет аккаунта?',
                        style: TextStyle(color: AppColors.darkGrey),
                      ),
                      const SizedBox(width: 6),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/register'
                          );
                        },
                        child: const Text(
                          'Регистрация',
                          style: TextStyle(
                            color: AppColors.darkBlue,
                          ),
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 3),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      showForgotPasswordDialog(context);
                    },
                    child: const Text(
                      'Забыли пароль?',
                      style: TextStyle(
                        color: AppColors.darkBlue,
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
