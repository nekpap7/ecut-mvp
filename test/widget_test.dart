import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Smoke test για το test harness.
///
/// Το πραγματικό root widget (`ECutApp` στο `main.dart`) χρησιμοποιεί Firebase Auth /
/// Firestore μέσω native plugins· σε unit/widget tests στο VM χρειάζεται είτε mocks
/// είτε [`integration_test`](https://docs.flutter.dev/testing/integration-tests)
/// σε συσκευή/emulator. Εδώ επιβεβαιώνουμε μόνο ότι το Flutter test τρέχει καθαρά.
void main() {
  testWidgets('MaterialApp mounts (smoke)', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('ok')),
        ),
      ),
    );

    expect(find.text('ok'), findsOneWidget);
  });
}
