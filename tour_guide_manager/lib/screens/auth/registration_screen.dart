import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_manager/colors.dart';

double fs(double base) =>
    base * (ScreenUtil().scaleWidth < 1 ? ScreenUtil().scaleWidth : 1);

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final nameController     = TextEditingController();
  final telegramController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    telegramController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: TextStyle(fontSize: fs(14))),
        backgroundColor: AppColors.darkBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _signUp() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final pass  = passwordController.text.trim();
    final tg    = telegramController.text.trim();
    final name  = nameController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _showSnack('Введите email и пароль');
      return setState(() => isLoading = false);
    }
    if (name.isEmpty) {
      _showSnack('Введите имя');
      return setState(() => isLoading = false);
    }
    if (tg.isEmpty) {
      _showSnack('Введите telegram');
      return setState(() => isLoading = false);
    }
    if (!tg.contains('@')) {
      _showSnack('Telegram не формата @username');
      return setState(() => isLoading = false);
    }

    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({'telegram': tg, 'excursionsDone': 0, 'name': name});
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      switch (e.code) {
        case 'email-already-in-use':
          _showSnack('Этот email уже используется');
          break;
        case 'weak-password':
          _showSnack('Пароль слишком простой');
          break;
        case 'invalid-email':
          _showSnack('Неверный формат email');
          break;
        default:
          _showSnack('Ошибка регистрации: ${e.message}');
      }
    } on FirebaseException catch (e) {
      if (mounted) _showSnack('Произошла ошибка: ${e.message}');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.darkBlue))
          : Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;

            final double boxWidth =
            (w < 600) ? w * 0.80
                : (w * 0.40).clamp(320, 640);

            final double k = (boxWidth / 360).clamp(1, 1.4);

            final double fieldH   = 48  * k;
            final double buttonH  = 40  * k;
            final double titleFs  = 22  * k;
            final double textFs   = 17  * k;
            final double hintFs   = 16  * k;
            final double smallFs  = 14  * k;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: boxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: _RegForm(
                    fieldH : fieldH,
                    buttonH: buttonH,
                    titleFs: titleFs,
                    textFs : textFs,
                    hintFs : hintFs,
                    smallFs: smallFs,
                  ),
                ),
              ),
            );
          },
        ),
      )
    );
  }

  Widget _input(TextEditingController c, String hint, bool obscure) => SizedBox(
    height: 48.h,
    child: TextField(
      controller: c,
      obscureText: obscure,
      cursorColor: AppColors.darkBlue,
      style: TextStyle(fontSize: fs(17)),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey, fontSize: fs(16)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
  );
}

class _RegForm extends StatelessWidget {
  const _RegForm({
    required this.fieldH,
    required this.buttonH,
    required this.titleFs,
    required this.textFs,
    required this.hintFs,
    required this.smallFs,
  });

  final double fieldH, buttonH, titleFs, textFs, hintFs, smallFs;

  @override
  Widget build(BuildContext context) {
    final state =
    context.findAncestorStateOfType<_RegistrationScreenState>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,          
      children: [
        Text('Создайте аккаунт',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: titleFs,
                color: AppColors.darkGrey)),
        SizedBox(height: 16.h),
        _input(state.emailController, 'Email', false),
        SizedBox(height: 8.h),
        _input(state.passwordController, 'Пароль', true),
        SizedBox(height: 8.h),
        _input(state.nameController, 'Имя и фамилия', false),
        SizedBox(height: 8.h),
        _input(state.telegramController, 'Telegram', false),
        SizedBox(height: 8.h),
        SizedBox(
          height: buttonH,
          width: double.infinity,
          child: FilledButton(
            onPressed: state._signUp,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Регистрация',
                style: TextStyle(
                    fontSize: textFs, fontWeight: FontWeight.w500)),
          ),
        ),
        SizedBox(height: 40.h),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6.w,
          runSpacing: 4,
          children: [
            Text('Уже есть аккаунт?',
                style: TextStyle(fontSize: smallFs, color: AppColors.darkGrey)),
            TextButton(
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text('Вход',
                  style: TextStyle(color: AppColors.darkBlue, fontSize: smallFs)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _input(TextEditingController c, String hint, bool obs) => SizedBox(
    height: fieldH,
    child: TextField(
      controller: c,
      obscureText: obs,
      cursorColor: AppColors.darkBlue,
      style: TextStyle(fontSize: textFs),
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.grey, fontSize: hintFs),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
  );
}
