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

  group('OrderScreen - Quantity & Pricing', () {
    testWidgets('shows initial quantity, bread, price and title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Quantity & sandwich type
      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);

      // Bread & note
      expect(find.text('Bread: white'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);

      // Toasted state & price
      expect(find.text('Untoasted'), findsOneWidget);
      expect(find.text('Total Price: \$0.00'), findsOneWidget);

      // AppBar title
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('increments quantity and updates price when Add is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();

      // 1 footlong, white bread
      expect(find.text('1 footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Bread: white'), findsOneWidget);

      // Pricing: 1 footlong = $7
      expect(find.text('Total Price: \$7.00'), findsOneWidget);
    });

    testWidgets('decrements quantity and updates price when Remove is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Go to quantity 1 first
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 footlong sandwich(es): 🥪'), findsOneWidget);
      expect(find.text('Total Price: \$7.00'), findsOneWidget);

      // Now remove back to 0
      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();

      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Total Price: \$0.00'), findsOneWidget);
    });

    testWidgets('does not decrement below zero', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Total Price: \$0.00'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();

      // Still zero, still zero price
      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Total Price: \$0.00'), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity (5)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }

      // App is configured with maxQuantity: 5
      expect(find.text('5 footlong sandwich(es): 🥪🥪🥪🥪🥪'), findsOneWidget);

      // Pricing: 5 footlong = 5 * 7 = 35
      expect(find.text('Total Price: \$35.00'), findsOneWidget);
    });

    testWidgets('switching to six-inch updates price per unit to \$11', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Set quantity to 2 first
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();

      // On footlong: 2 * 7 = 14
      expect(find.text('2 footlong sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Total Price: \$14.00'), findsOneWidget);

      // Toggle to six-inch
      await tester.tap(find.byKey(const Key('size_switch')));
      await tester.pump();

      // Now six-inch at 2 * 11 = 22
      expect(find.text('2 six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Total Price: \$22.00'), findsOneWidget);
    });
  });

  group('OrderScreen - Controls', () {
    testWidgets('changes bread type with DropdownMenu', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Open dropdown and select wheat
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('wheat').last);
      await tester.pumpAndSettle();
      expect(find.text('Bread: wheat'), findsOneWidget);

      // Open dropdown and select multigrain
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('multigrain').last);
      await tester.pumpAndSettle();
      expect(find.text('Bread: multigrain'), findsOneWidget);
    });

    testWidgets('updates note with TextField', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.enterText(
        find.byKey(const Key('notes_textfield')),
        'Extra mayo',
      );
      await tester.pump();

      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });

    testWidgets('toggles sandwich size via Switch', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Initial: footlong
      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);

      // Toggle to six-inch
      await tester.tap(find.byKey(const Key('size_switch')));
      await tester.pump();
      expect(find.text('0 six-inch sandwich(es): '), findsOneWidget);

      // Toggle back to footlong
      await tester.tap(find.byKey(const Key('size_switch')));
      await tester.pump();
      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('toggles toasted state via Switch and updates text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const App());

      // Initial: Untoasted
      expect(find.text('Untoasted'), findsOneWidget);

      // Toggle to toasted
      await tester.tap(find.byKey(const Key('toasted_switch')));
      await tester.pump();
      expect(find.text('Toasted'), findsOneWidget);

      // Toggle back to untoasted
      await tester.tap(find.byKey(const Key('toasted_switch')));
      await tester.pump();
      expect(find.text('Untoasted'), findsOneWidget);
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

  group('OrderItemDisplay', () {
    testWidgets('shows correct text, note and price for zero sandwiches', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 0,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
        price: 0.0,
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);

      expect(find.text('0 footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Bread: white'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
      expect(find.text('Untoasted'), findsOneWidget);
      expect(find.text('Total Price: \$0.00'), findsOneWidget);
    });

    testWidgets('shows correct text, emoji and price for three sandwiches', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 3,
        itemType: 'footlong',
        breadType: BreadType.white,
        orderNote: 'No notes added.',
        price: 21.0, // 3 * 7
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);

      expect(find.text('3 footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
      expect(find.text('Bread: white'), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
      expect(find.text('Total Price: \$21.00'), findsOneWidget);
    });

    testWidgets('shows correct bread, type and price for two six-inch wheat', (
      WidgetTester tester,
    ) async {
      const widgetToBeTested = OrderItemDisplay(
        quantity: 2,
        itemType: 'six-inch',
        breadType: BreadType.wheat,
        orderNote: 'No pickles',
        price: 22.0, // 2 * 11
      );
      const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
      await tester.pumpWidget(testApp);

      expect(find.text('2 six-inch sandwich(es): 🥪🥪'), findsOneWidget);
      expect(find.text('Bread: wheat'), findsOneWidget);
      expect(find.text('Note: No pickles'), findsOneWidget);
      expect(find.text('Total Price: \$22.00'), findsOneWidget);
    });

    testWidgets(
      'shows correct bread, type and price for one multigrain footlong',
      (WidgetTester tester) async {
        const widgetToBeTested = OrderItemDisplay(
          quantity: 1,
          itemType: 'footlong',
          breadType: BreadType.multigrain,
          orderNote: 'Lots of lettuce',
          price: 7.0,
        );
        const testApp = MaterialApp(home: Scaffold(body: widgetToBeTested));
        await tester.pumpWidget(testApp);

        expect(find.text('1 footlong sandwich(es): 🥪'), findsOneWidget);
        expect(find.text('Bread: multigrain'), findsOneWidget);
        expect(find.text('Note: Lots of lettuce'), findsOneWidget);
        expect(find.text('Total Price: \$7.00'), findsOneWidget);
      },
    );
  });
}
