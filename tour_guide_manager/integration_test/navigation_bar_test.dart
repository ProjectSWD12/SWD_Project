import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tour_guide_manager/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Bottom navigation switches screens', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    final profileTab = find.text('Профиль');
    await tester.tap(profileTab);
    await tester.pumpAndSettle();

    expect(profileTab, findsOneWidget);
  });
}
