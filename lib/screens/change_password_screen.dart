import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final emailController = TextEditingController();

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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Восстановите аккаунт',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
                color: Color(0xff333333),
              ),
            ),
            SizedBox(height: 8),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Color(0xff005BFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                    child: Text(
                      'Назад',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      String email = emailController.text;
                      _sendPasswordResetEmail(email);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Color(0xff005BFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                        )
                    ),
                    child: Text(
                      'Продолжить',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
