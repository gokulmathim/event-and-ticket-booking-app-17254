import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/cart_provider.dart';
import 'confirmation_screen.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _agree = true;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final booking = context.watch<BookingProvider>();
    final total = cart.total;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Order summary', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: cart.items
                  .map((i) => ListTile(
                        title: Text(i.event.title),
                        subtitle: Text('${i.seats.length} seats'),
                        trailing: Text('\$${i.total.toStringAsFixed(2)}'),
                      ))
                  .toList(),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: _agree,
                onChanged: (v) => setState(() => _agree = v ?? false),
              ),
              const Expanded(child: Text('I agree to the Terms and Privacy Policy')),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: booking.isProcessing || !_agree || total == 0
                ? null
                : () async {
                    final id = await context.read<BookingProvider>().checkout(cart.items);
                    if (!mounted) return;
                    if (id != null) {
                      cart.clear();
                      Navigator.of(context)
                          .pushReplacementNamed(ConfirmationScreen.routeName, arguments: id);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Payment failed')));
                    }
                  },
            icon: booking.isProcessing
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.payment),
            label: Text(booking.isProcessing ? 'Processing...' : 'Pay \$${total.toStringAsFixed(2)}'),
          ),
        ]),
      ),
    );
  }
}
