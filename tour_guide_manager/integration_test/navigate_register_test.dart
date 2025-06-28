import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tour_guide_manager/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate to registration screen', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    final registerButton = find.text('Регистрация');
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    expect(find.text('Создайте аккаунт'), findsOneWidget);
  });
}
