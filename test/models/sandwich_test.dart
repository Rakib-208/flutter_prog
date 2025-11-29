import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_prog/models/sandwich.dart';

void main() {
  group('Sandwich.name', () {
    test('returns correct name for veggieDelight', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      expect(sandwich.name, 'Veggie Delight');
    });

    test('returns correct name for chickenTeriyaki', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: true,
        breadType: BreadType.white,
      );
      expect(sandwich.name, 'Chicken Teriyaki');
    });

    test('returns correct name for tunaMelt', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(sandwich.name, 'Tuna Melt');
    });

    test('returns correct name for meatballMarinara', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: false,
        breadType: BreadType.wholemeal,
      );
      expect(sandwich.name, 'Meatball Marinara');
    });
  });

  group('Sandwich.image', () {
    test('builds correct image path for footlong veggieDelight', () {
      final sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      expect(
        sandwich.image,
        'assets/images/${SandwichType.veggieDelight.name}_footlong.jpeg',
      );
    });

    test('builds correct image path for six-inch chickenTeriyaki', () {
      final sandwich = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.white,
      );
      expect(
        sandwich.image,
        'assets/images/${SandwichType.chickenTeriyaki.name}_six_inch.jpeg',
      );
    });

    test('builds correct image path for six-inch tunaMelt', () {
      final sandwich = Sandwich(
        type: SandwichType.tunaMelt,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      expect(
        sandwich.image,
        'assets/images/${SandwichType.tunaMelt.name}_six_inch.jpeg',
      );
    });

    test('builds correct image path for footlong meatballMarinara', () {
      final sandwich = Sandwich(
        type: SandwichType.meatballMarinara,
        isFootlong: true,
        breadType: BreadType.wholemeal,
      );
      expect(
        sandwich.image,
        'assets/images/${SandwichType.meatballMarinara.name}_footlong.jpeg',
      );
    });
  });
}
