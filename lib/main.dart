import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Myths App",
      home: Scaffold(
        appBar: AppBar(title: const Text("Myths App")),
        body: const Center(child: Text("Welcome to Myths App!")),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final String itemType;
  final int quantity;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text('This is a placeholder for OrderItemDisplay');
  }
}
