import 'package:flutter/material.dart';
import '../ticket/digital_ticket_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  static const routeName = '/booking/confirmation';
  final String bookingId;
  const ConfirmationScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmed')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 88, color: Colors.green),
              const SizedBox(height: 12),
              const Text('Your booking is confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Booking ID: $bookingId'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(DigitalTicketScreen.routeName, arguments: bookingId);
                },
                icon: const Icon(Icons.confirmation_number),
                label: const Text('View Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
