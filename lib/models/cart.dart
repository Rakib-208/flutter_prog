import 'package:flutter_prog/models/sandwich.dart';
import 'package:flutter_prog/repositories/pricing_repository.dart';

/// Represents a single line in the cart: a [sandwich] with a given [quantity].
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, this.quantity = 1})
    : assert(quantity >= 0, 'Quantity cannot be negative.');

  /// Helper: whether this line corresponds to the exact same sandwich
  /// configuration (type + size + bread).
  bool isSameSandwich(Sandwich other) {
    return sandwich.type == other.type &&
        sandwich.isFootlong == other.isFootlong &&
        sandwich.breadType == other.breadType;
  }
}

/// Cart model that behaves like a typical e-commerce cart.
///
/// It holds multiple [CartItem]s, delegates all price calculations to
/// [PricingRepository], and exposes convenience getters for totals.
class Cart {
  final PricingRepository _pricingRepository;
  final List<CartItem> _items = [];

  Cart({PricingRepository? pricingRepository})
    : _pricingRepository = pricingRepository ?? PricingRepository();

  /// Read-only view of cart items.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Whether the cart has no items.
  bool get isEmpty => _items.isEmpty;

  /// Number of distinct sandwich lines in the cart.
  int get totalUniqueSandwiches => _items.length;

  /// Total number of sandwiches (sum of quantities for all lines).
  int get totalQuantity =>
      _items.fold<int>(0, (sum, item) => sum + item.quantity);

  /// Total price for a single [CartItem] line.
  double lineTotal(CartItem item) {
    return _pricingRepository.calculatePrice(
      quantity: item.quantity,
      isFootlong: item.sandwich.isFootlong,
    );
  }

  /// Grand total price for the whole cart.
  double get totalPrice =>
      _items.fold<double>(0.0, (sum, item) => sum + lineTotal(item));

  /// Adds [quantity] of [sandwich] to the cart.
  ///
  /// If the same sandwich (same type, size, bread) already exists,
  /// its quantity is incremented. Otherwise a new line is created.
  void addSandwich(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;

    final int existingIndex = _indexOfSandwich(sandwich);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Sets the quantity of [sandwich] to [quantity].
  ///
  /// If [quantity] is 0 or less, the sandwich is removed from the cart.
  void setQuantity(Sandwich sandwich, int quantity) {
    final int index = _indexOfSandwich(sandwich);
    if (index == -1) {
      if (quantity > 0) {
        _items.add(CartItem(sandwich: sandwich, quantity: quantity));
      }
      return;
    }

    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index].quantity = quantity;
    }
  }

  /// Removes a single unit of [sandwich] from the cart.
  ///
  /// If the quantity would drop to 0, the line is removed entirely.
  void removeOne(Sandwich sandwich) {
    final int index = _indexOfSandwich(sandwich);
    if (index == -1) return;

    final CartItem item = _items[index];
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeAt(index);
    }
  }

  /// Removes all instances of [sandwich] from the cart.
  void removeSandwichCompletely(Sandwich sandwich) {
    final int index = _indexOfSandwich(sandwich);
    if (index != -1) {
      _items.removeAt(index);
    }
  }

  /// Clears the cart fully.
  void clear() {
    _items.clear();
  }

  /// Internal: find index of a sandwich line with same configuration.
  int _indexOfSandwich(Sandwich sandwich) {
    return _items.indexWhere((item) => item.isSameSandwich(sandwich));
  }
}
