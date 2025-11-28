import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prog/models/cart.dart';
import 'package:flutter_prog/models/sandwich.dart';

void main() {
  group('Cart model', () {
    late Sandwich footlongVeggie;
    late Sandwich sixInchVeggie;

    setUp(() {
      footlongVeggie = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );

      sixInchVeggie = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: false,
        breadType: BreadType.white,
      );
    });

    test('new cart is empty with zero totals', () {
      final cart = Cart();

      expect(cart.isEmpty, isTrue);
      expect(cart.totalQuantity, 0);
      expect(cart.totalUniqueSandwiches, 0);
      expect(cart.totalPrice, 0.0);
      expect(cart.items, isEmpty);
    });

    test('addSandwich adds a new line with correct quantity and price', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie);

      expect(cart.isEmpty, isFalse);
      expect(cart.totalUniqueSandwiches, 1);
      expect(cart.totalQuantity, 1);

      final item = cart.items.first;
      expect(item.sandwich, footlongVeggie);
      expect(item.quantity, 1);

      // PricingRepository: isFootlong == true → 11.00 each
      expect(cart.totalPrice, 11.0);
    });

    test('adding the same sandwich increases quantity, not lines', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie);
      cart.addSandwich(footlongVeggie);

      expect(cart.totalUniqueSandwiches, 1);
      expect(cart.totalQuantity, 2);

      final item = cart.items.first;
      expect(item.quantity, 2);

      // 2 * 11.00 = 22.00
      expect(cart.totalPrice, 22.0);
    });

    test('adding different sandwich variants creates multiple lines', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie);   // 1 x footlong (11)
      cart.addSandwich(sixInchVeggie);    // 1 x six-inch (7)

      expect(cart.totalUniqueSandwiches, 2);
      expect(cart.totalQuantity, 2);

      // 11 + 7 = 18
      expect(cart.totalPrice, 18.0);
    });

    test('removeOne decreases quantity, removes line at zero', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie, quantity: 2);
      expect(cart.totalQuantity, 2);

      cart.removeOne(footlongVeggie);
      expect(cart.totalQuantity, 1);
      expect(cart.totalUniqueSandwiches, 1);

      cart.removeOne(footlongVeggie);
      expect(cart.totalQuantity, 0);
      expect(cart.totalUniqueSandwiches, 0);
      expect(cart.isEmpty, isTrue);
    });

    test('removeSandwichCompletely removes the whole line regardless of qty', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie, quantity: 3);
      cart.addSandwich(sixInchVeggie, quantity: 1);

      expect(cart.totalUniqueSandwiches, 2);
      expect(cart.totalQuantity, 4);

      cart.removeSandwichCompletely(footlongVeggie);

      expect(cart.totalUniqueSandwiches, 1);
      expect(cart.totalQuantity, 1);
      expect(cart.items.first.sandwich, sixInchVeggie);
    });

    test('setQuantity updates or removes items correctly', () {
      final cart = Cart();

      // If item is not yet in cart, setQuantity should add it
      cart.setQuantity(footlongVeggie, 3);
      expect(cart.totalUniqueSandwiches, 1);
      expect(cart.totalQuantity, 3);

      // Update quantity down to 1
      cart.setQuantity(footlongVeggie, 1);
      expect(cart.totalQuantity, 1);

      // Set quantity to 0 → remove line
      cart.setQuantity(footlongVeggie, 0);
      expect(cart.totalUniqueSandwiches, 0);
      expect(cart.totalQuantity, 0);
    });

    test('clear empties the cart fully', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie, quantity: 2);
      cart.addSandwich(sixInchVeggie, quantity: 1);

      expect(cart.isEmpty, isFalse);

      cart.clear();
      expect(cart.isEmpty, isTrue);
      expect(cart.totalQuantity, 0);
      expect(cart.items, isEmpty);
    });

    test('lineTotal uses PricingRepository per item', () {
      final cart = Cart();

      cart.addSandwich(footlongVeggie, quantity: 2); // 2 x 11
      final item = cart.items.first;

      // Line total: 22
      expect(cart.lineTotal(item), 22.0);
    });
  });
}
