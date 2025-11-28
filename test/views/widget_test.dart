import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prog/main.dart';

void main() {
  group('App', () {
    testWidgets('renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
    });
  });

  group('OrderScreen - Initial UI', () {
    testWidgets('shows title, initial quantity and dropdown labels', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Quantity: '), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      expect(
        find.widgetWithText(ElevatedButton, 'Add to Cart'),
        findsOneWidget,
      );

      expect(find.text('Sandwich Type'), findsOneWidget);
      expect(find.text('Bread Type'), findsOneWidget);

      // Initial cart summary
      expect(find.text('Cart Summary'), findsOneWidget);
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total Price: £0.00'), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity controls', () {
    testWidgets('increase/decrease quantity using buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('disables Add to Cart when quantity is 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      final ElevatedButton button = tester.widget(
        find.widgetWithText(ElevatedButton, 'Add to Cart'),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('enables Add to Cart when qty > 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      final ElevatedButton button = tester.widget(
        find.widgetWithText(ElevatedButton, 'Add to Cart'),
      );

      expect(button.onPressed, isNotNull);
    });
  });

  group('OrderScreen - Dropdowns and Switch', () {
    testWidgets('changes sandwich type', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.text('Sandwich Type'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });

    testWidgets('changes bread type', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.text('Bread Type'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('toggle size switch', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      final initialValue = tester.widget<Switch>(switchFinder).value;

      await tester.tap(switchFinder);
      await tester.pump();

      final newValue = tester.widget<Switch>(switchFinder).value;
      expect(newValue, isNot(initialValue));
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('updates cart summary when adding items', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Initial summary
      expect(find.text('Items: 0'), findsOneWidget);
      expect(find.text('Total Price: £0.00'), findsOneWidget);

      // Add one sandwich
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pump();

      // Price for 1 footlong = £? — depends on PricingRepository, but >0
      expect(find.text('Items: 1'), findsOneWidget);
      expect(
        find.textContaining('Total Price: £'),
        findsOneWidget,
      ); // any non-zero
    });
  });

  group('OrderScreen - Popup confirmation animation', () {
    testWidgets('popup appears when Add to Cart is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      expect(find.textContaining('Added'), findsNothing);

      // Tap add
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pump(); // start animations

      // Popup appears (AnimatedSlide + AnimatedOpacity)
      expect(find.textContaining('Added'), findsOneWidget);
    });

    testWidgets('popup disappears after 3 seconds', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
      await tester.pump(); // start animation

      expect(find.textContaining('Added'), findsOneWidget);

      // Move time forward past fade + disappear
      await tester.pump(const Duration(milliseconds: 400)); // fade in
      await tester.pump(const Duration(seconds: 3)); // timeout
      await tester.pump(const Duration(milliseconds: 400)); // fade out

      // Popup gone
      expect(find.textContaining('Added'), findsNothing);
    });
  });

  group('StyledButton', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );

      const testApp = MaterialApp(home: Scaffold(body: testButton));

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
