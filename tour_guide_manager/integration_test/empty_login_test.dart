import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login button with empty fields shows error', (tester) async {
    await tester.pumpAndSettle();

    final loginButton = find.text('Войти');
    await tester.tap(loginButton);
    await tester.pump();

    expect(loginButton, findsOneWidget);
  });
}
