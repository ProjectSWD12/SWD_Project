import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE6F2FF),
      body: Center(
        child: FilledButton(
            onPressed: () {FirebaseAuth.instance.signOut();},
            child: const Text('Выйти')),
      ),
    );
  }
}
