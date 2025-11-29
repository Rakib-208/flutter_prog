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
    testWidgets('App boots and OrderScreen renders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
    });

    testWidgets('Quantity increment/decrement works', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final Finder addFinder = find.byIcon(Icons.add);
      final Finder removeFinder = find.byIcon(Icons.remove);

      // Ensure buttons are visible
      await ensureVisible(tester, addFinder);

      // Initial quantity should be 1
      expect(find.text('1'), findsOneWidget);

      // Increment
      await tester.tap(addFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // Decrement
      await tester.tap(removeFinder);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Add to Cart triggers popup and updates cart summary', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final Finder addToCartFinder = find.text('Add to Cart');

      // Ensure the button is visible (handles scrollable layout)
      await ensureVisible(tester, addToCartFinder);

      // Tap Add to Cart
      await tester.tap(addToCartFinder);
      await tester.pump(); // start popup animation frame

      // Popup should appear with an "Added ..." message
      expect(find.textContaining('Added'), findsOneWidget);

      // Advance fake time so the Future.delayed(3s) in _triggerPopup completes
      // and the hide animation has time to run. This clears the pending timer.
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      // We do not assert that the popup text is gone, because the widget keeps
      // the Text in the tree with zero opacity; Finder will still see it.
      // Instead, we just verify that the cart summary reflects the added item.
      expect(find.textContaining('Items: 1'), findsOneWidget);
    });
  });
}
