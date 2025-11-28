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
    testWidgets('shows title, image placeholder and initial quantity', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Title
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Quantity row
      expect(find.text('Quantity: '), findsOneWidget);
      expect(find.text('1'), findsOneWidget); // initial _quantity = 1

      // Add to Cart button
      expect(
        find.widgetWithText(ElevatedButton, 'Add to Cart'),
        findsOneWidget,
      );

      // Sandwich type dropdown label
      expect(find.text('Sandwich Type'), findsOneWidget);

      // Bread type dropdown label
      expect(find.text('Bread Type'), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity controls', () {
    testWidgets('increases and decreases quantity with IconButtons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // initial quantity is 1
      expect(find.text('1'), findsOneWidget);

      // Tap + to increase
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      // Tap - to decrease
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      // Decrease to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('disables Add to Cart when quantity is 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Bring quantity down to 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Locate the ElevatedButton inside StyledButton
      final ElevatedButton button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Add to Cart'),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets('enables Add to Cart when quantity is greater than 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // initial quantity = 1
      final ElevatedButton button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Add to Cart'),
      );

      expect(button.onPressed, isNotNull);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes sandwich type with DropdownMenu<SandwichType>', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Open sandwich type dropdown
      await tester.tap(find.text('Sandwich Type'));
      await tester.pumpAndSettle();

      // Select "Chicken Teriyaki" (from Sandwich.name)
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // The new selection text should be visible somewhere
      expect(find.text('Chicken Teriyaki'), findsWidgets);
    });

    testWidgets('changes bread type with DropdownMenu<BreadType>', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Open bread type dropdown
      await tester.tap(find.text('Bread Type'));
      await tester.pumpAndSettle();

      // Select wheat
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();

      // There should now be a 'wheat' text widget (selected item)
      expect(find.text('wheat'), findsWidgets);
    });

    testWidgets('toggles size via Switch', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Locate the size switch (there is only one Switch in this screen)
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);

      Switch sizeSwitch = tester.widget<Switch>(switchFinder);
      final bool initialValue = sizeSwitch.value;

      // Toggle the switch
      await tester.tap(switchFinder);
      await tester.pump();

      sizeSwitch = tester.widget<Switch>(switchFinder);
      expect(sizeSwitch.value, isNot(initialValue));
    });
  });

  group('StyledButton', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
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
