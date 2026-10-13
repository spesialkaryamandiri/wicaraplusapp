// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:wicaraplusapp/main.dart';
import 'package:wicaraplusapp/splash_screen.dart';

void main() {
  testWidgets('MyApp renders SplashScreen smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MyApp(initializeServices: () async {}));
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('MyApp offers retry when required startup services fail', (
    WidgetTester tester,
  ) async {
    var shouldFail = true;

    await tester.pumpWidget(
      MyApp(
        initializeServices: () async {
          if (shouldFail) {
            throw StateError('Firebase is unavailable');
          }
        },
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Coba lagi'), findsOneWidget);

    shouldFail = false;
    await tester.tap(find.text('Coba lagi'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
