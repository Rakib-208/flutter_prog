/// Pricing rules:
/// - 1 footlong sandwich  = $7
/// - 1 six-inch sandwich  = $11
class PricingRepository {
  static const double footlongPrice = 7.0;
  static const double sixInchPrice = 11.0;

  /// Calculates total price given [quantity] and [sandwichType].
  ///
  /// [sandwichType] should be either 'footlong' or 'six-inch'.
  double calculatePrice({
    required int quantity,
    required String sandwichType,
  }) {
    if (quantity <= 0) return 0.0;

    final double unitPrice =
        sandwichType == 'six-inch' ? sixInchPrice : footlongPrice;

    return unitPrice * quantity;
  }
}
