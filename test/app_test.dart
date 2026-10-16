import 'package:flutter_test/flutter_test.dart';
import 'package:hki_mobile/main.dart';

void main() {
  testWidgets('starts the counter feature and increments its state', (
    tester,
  ) async {
    await tester.pumpWidget(const HkiApp());
    await tester.pumpAndSettle();

    expect(find.text('Clean Architecture + GetX'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOneWidget);
  });
}
