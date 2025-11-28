import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prog/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper: scroll until a widget is visible
  Future<void> ensureVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  group('OrderScreen UI flow', () {
    testWidgets('App boots and OrderScreen renders', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('Quantity increment/decrement works', (tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final addFinder = find.byIcon(Icons.add);
      final removeFinder = find.byIcon(Icons.remove);

      // Bring into view first
      await ensureVisible(tester, addFinder);

      expect(find.text('1'), findsOneWidget);

      await tester.tap(addFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      await tester.tap(removeFinder);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Add to Cart triggers popup and updates cart summary', (
      tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final addToCartFinder = find.text('Add to Cart');
      await ensureVisible(tester, addToCartFinder);

      await tester.tap(addToCartFinder);
      await tester.pump(); // Start popup animation

      // Popup appears
      expect(find.textContaining('Added'), findsOneWidget);

      // Let popup hide
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));

      // Popup should now disappear
      expect(find.textContaining('Added'), findsNothing);

      // Cart summary validation
      expect(find.textContaining('Items: 1'), findsOneWidget);
    });
  });
}
