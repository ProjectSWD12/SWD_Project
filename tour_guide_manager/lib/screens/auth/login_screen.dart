import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tour_guide_manager/colors.dart';
import 'package:tour_guide_manager/widgets/top_snack_bar.dart';

double fs(double base) =>
    base * (ScreenUtil().scaleWidth < 1 ? ScreenUtil().scaleWidth : 1);



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
    setState(() => isLoading = true);
    try {
      final email = emailController.text.trim();
      final pass  = passwordController.text.trim();
      if (email.isEmpty || pass.isEmpty) {
        showTopSnackBar(context, 'Введите email и пароль');
        setState(() => isLoading = false);
        return;
      }
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: pass);
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
      if (mounted) showTopSnackBar(context, 'Неизвестная ошибка: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _sendPasswordResetEmail(String mail) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
      if (mounted) showTopSnackBar(context, 'Письмо отправлено на почту');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        switch (e.code) {
          case 'invalid-email':
            showTopSnackBar(context, 'Некорректный email адрес');
            break;
          case 'user-not-found':
            showTopSnackBar(context, 'Пользователь с таким email не найден');
            break;
          default:
            showTopSnackBar(context, 'Произошла ошибка: ${e.message}');
        }
      }
    }
  }

  void _forgotDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text('Забыли пароль?',
            style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.darkGrey)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Введите email для восстановления доступа',
                style: TextStyle(fontSize: fs(16), color: const Color(0xff333333))),
            SizedBox(height: 16.h),
            SizedBox(
              height: 48,
              child: TextField(
                controller: ctrl,
                cursorColor: AppColors.darkBlue,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: fs(15)),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Отмена',
                  style: TextStyle(
                      color: AppColors.darkBlue, fontWeight: FontWeight.w500))),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.darkBlue),
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                _sendPasswordResetEmail(ctrl.text.trim());
                Navigator.pop(context);
              }
            },
            child: Text('Отправить',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: fs(15))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double formWidth =
    MediaQuery.of(context).size.width < 400
        ? MediaQuery.of(context).size.width
        : 400;
    return Scaffold(
        backgroundColor: AppColors.background,
        body: isLoading
            ? const Center(
            child: CircularProgressIndicator(color: AppColors.darkBlue))
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
                    child: _LoginForm(
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
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
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
    final state = context.findAncestorStateOfType<_LoginScreenState>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Войдите в аккаунт',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: titleFs,
                color: AppColors.darkGrey)),
        SizedBox(height: 16.h),
        SizedBox(
          height: fieldH,
          child: TextField(
            controller: state.emailController,
            cursorColor: AppColors.darkBlue,
            style: TextStyle(fontSize: textFs),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
              EdgeInsets.symmetric(vertical: 13, horizontal: 16),
              hintText: 'Email',
              hintStyle:
              TextStyle(color: AppColors.grey, fontSize: hintFs),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: fieldH,
          child: TextField(
            controller: state.passwordController,
            obscureText: true,
            cursorColor: AppColors.darkBlue,
            style: TextStyle(fontSize: textFs),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
              EdgeInsets.symmetric(vertical: 13, horizontal: 16),
              hintText: 'Пароль',
              hintStyle:
              TextStyle(color: AppColors.grey, fontSize: hintFs),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: buttonH,
          width: double.infinity,
          child: FilledButton(
            onPressed: state._signIn,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Войти',
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
            Text('Нет аккаунта?',
                style: TextStyle(color: AppColors.darkGrey, fontSize: smallFs)),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/register'),
              child: Text('Регистрация',
                  style: TextStyle(
                      color: AppColors.darkBlue, fontSize: smallFs)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: state._forgotDialog,
              child: Text('Забыли пароль?',
                  style: TextStyle(
                      color: AppColors.darkBlue, fontSize: smallFs)),
            ),
          ],
        ),
      ],
    );
  }
}
