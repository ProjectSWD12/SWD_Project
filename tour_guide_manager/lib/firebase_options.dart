// Заглушка firebase_options.dart для тестов

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'fake-api-key',
      appId: '1:1234567890:web:fake-app-id',
      messagingSenderId: '1234567890',
      projectId: 'fake-project-id',
    );
  }
}
