import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  // Centralized reusable button styles
  static ButtonStyle _buildStyle({
    required Color activeBg,
    required Color activeFg,
    required Color disabledBg,
    required Color disabledFg,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return disabledBg;
        return activeBg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) return disabledFg;
        return activeFg;
      }),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      elevation: WidgetStateProperty.resolveWith<double>((states) {
        if (states.contains(WidgetState.disabled)) return 0;
        if (states.contains(WidgetState.pressed)) return 2;
        return 4;
      }),
    );
  }

  static final ButtonStyle addButtonStyle = _buildStyle(
    activeBg: Colors.green.shade800,
    activeFg: Colors.white,
    disabledBg: Colors.grey,
    disabledFg: Colors.black54,
  );

  static final ButtonStyle removeButtonStyle = _buildStyle(
    activeBg: Colors.red,
    activeFg: Colors.white,
    disabledBg: Colors.grey,
    disabledFg: Colors.black54,
  );

  static final ButtonStyle backButtonStyle = _buildStyle(
    activeBg: Colors.blue,
    activeFg: Colors.white,
    disabledBg: Colors.blueGrey,
    disabledFg: Colors.white70,
  );

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('$quantity $itemType sandwich(es): ${'🥪' * quantity}');
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({super.key, this.maxQuantity = 10});
  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  String? _selectedItemType; // newly added

  void _select(String type) {
    setState(() {
      _selectedItemType = type;
      _quantity = 0; // reset counter on selection
    });
  }

  void _clearSelection() {
    // added
    setState(() {
      _selectedItemType = null;
      _quantity = 0;
    });
  }

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAddDisabled = _quantity >= widget.maxQuantity;
    final isRemoveDisabled = _quantity <= 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: Center(
        child: _selectedItemType == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _select('Footlong'),
                    child: const Text('Footlong Sandwich'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _select('Six-inch'),
                    child: const Text('Six-Inch Sandwich'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OrderItemDisplay(_quantity, _selectedItemType!),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isAddDisabled ? null : _increaseQuantity,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.grey;
                                }
                                return Colors.green[800]!;
                              }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.black54;
                                }
                                return Colors.white;
                              }),
                        ),
                        child: const Text('Add'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: isRemoveDisabled ? null : _decreaseQuantity,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.grey;
                                }
                                return Colors.red;
                              }),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.black54;
                                }
                                return Colors.white;
                              }),
                        ),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _clearSelection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Back'),
                  ),
                ],
              ),
      ),
    );
  }
}
