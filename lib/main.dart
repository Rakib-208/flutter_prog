import 'package:flutter/material.dart';
import 'package:flutter_prog/views/app_styles.dart';
import 'package:flutter_prog/models/sandwich.dart';
import 'package:flutter_prog/models/cart.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sandwich Shop App', home: OrderScreen());
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final Cart _cart = Cart();
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  // Temporary confirmation message
  String _uiConfirmationMessage = "";

  @override
  void initState() {
    super.initState();
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_quantity > 0) {
      final Sandwich sandwich = Sandwich(
        type: _selectedSandwichType,
        isFootlong: _isFootlong,
        breadType: _selectedBreadType,
      );

      setState(() {
        _cart.add(sandwich, quantity: _quantity);
      });

      String sizeText = _isFootlong ? 'footlong' : 'six-inch';

      String confirmationMessage =
          'Added $_quantity $sizeText ${sandwich.name} sandwich(es) on ${_selectedBreadType.name} bread to cart';

      // Activate confirmation message
      setState(() => _uiConfirmationMessage = confirmationMessage);

      // Auto-dismiss after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _uiConfirmationMessage = "";
          });
        }
      });

      debugPrint(confirmationMessage);
    }
  }

  VoidCallback? _getAddToCartCallback() {
    return _quantity > 0 ? _addToCart : null;
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    return SandwichType.values.map((type) {
      Sandwich sandwich = Sandwich(
        type: type,
        isFootlong: true,
        breadType: BreadType.white,
      );
      return DropdownMenuEntry<SandwichType>(value: type, label: sandwich.name);
    }).toList();
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    return BreadType.values
        .map(
          (bread) =>
              DropdownMenuEntry<BreadType>(value: bread, label: bread.name),
        )
        .toList();
  }

  String _getCurrentImagePath() {
    final Sandwich sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );
    return sandwich.image;
  }

  void _onSandwichTypeChanged(SandwichType? value) {
    if (value != null) setState(() => _selectedSandwichType = value);
  }

  void _onSizeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeChanged(BreadType? value) {
    if (value != null) setState(() => _selectedBreadType = value);
  }

  void _increaseQuantity() {
    setState(() => _quantity++);
  }

  void _decreaseQuantity() {
    if (_quantity > 0) setState(() => _quantity--);
  }

  VoidCallback? _getDecreaseCallback() {
    return _quantity > 0 ? _decreaseQuantity : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter', style: heading1)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text('Image not found', style: normalText),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              DropdownMenu<SandwichType>(
                width: double.infinity,
                label: const Text('Sandwich Type'),
                textStyle: normalText,
                initialSelection: _selectedSandwichType,
                onSelected: _onSandwichTypeChanged,
                dropdownMenuEntries: _buildSandwichTypeEntries(),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Six-inch', style: normalText),
                  Switch(value: _isFootlong, onChanged: _onSizeChanged),
                  const Text('Footlong', style: normalText),
                ],
              ),
              const SizedBox(height: 20),

              DropdownMenu<BreadType>(
                width: double.infinity,
                label: const Text('Bread Type'),
                textStyle: normalText,
                initialSelection: _selectedBreadType,
                onSelected: _onBreadTypeChanged,
                dropdownMenuEntries: _buildBreadTypeEntries(),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: _getDecreaseCallback(),
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: heading2),
                  IconButton(
                    onPressed: _increaseQuantity,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              StyledButton(
                onPressed: _getAddToCartCallback(),
                icon: Icons.add_shopping_cart,
                label: 'Add to Cart',
                backgroundColor: Colors.green,
              ),
              const SizedBox(height: 20),

              // --- CART SUMMARY ---
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      'Cart Summary',
                      style: heading2.copyWith(color: Colors.blue.shade700),
                    ),
                    const SizedBox(height: 8),
                    Text('Items: ${_cart.totalQuantity}', style: normalText),
                    Text(
                      'Total Price: £${_cart.totalPrice.toStringAsFixed(2)}',
                      style: normalText,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- AUTO-DISMISSING CONFIRMATION MESSAGE ---
              if (_uiConfirmationMessage.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade700),
                  ),
                  child: Text(
                    _uiConfirmationMessage,
                    style: normalText.copyWith(color: Colors.green.shade900),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Styled Button
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: onPressed == null ? 0 : 4,
        textStyle: normalText,
      ),
    );
  }
}
