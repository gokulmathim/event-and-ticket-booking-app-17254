import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _CartItemTile(item: items[i]),
                  ),
                ),
                _TotalFooter(total: cart.total),
              ],
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(item.event.title),
        subtitle: Text('${item.seats.length} seats • \$${item.total.toStringAsFixed(2)}'),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Wrap(
            spacing: 8,
            children: item.seats
                .map((s) => Chip(
                      label: Text('R${s.row + 1}-C${s.col + 1}'),
                      onDeleted: () => context.read<CartProvider>().remove(item.event.id, s.id),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TotalFooter extends StatelessWidget {
  final double total;
  const _TotalFooter({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withAlpha(20))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ),
          ElevatedButton.icon(
            onPressed: total == 0
                ? null
                : () {
                    Navigator.of(context).pushNamed(CheckoutScreen.routeName);
                  },
            icon: const Icon(Icons.lock),
            label: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
