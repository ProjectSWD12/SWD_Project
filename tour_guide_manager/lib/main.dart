import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/applications.dart';
import 'screens/auth/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile.dart';
import 'screens/calendar.dart';
import 'screens/auth/login_screen.dart';
import 'firebase_options.dart';
import 'colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tour Guide Manager',
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/profile': (context) => const Profile(),
        '/calendar': (context) => const Calendar(),
        '/auth': (context) => const AuthGate(),
        '/applications': (context) => const Applications()
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue)
            )
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
