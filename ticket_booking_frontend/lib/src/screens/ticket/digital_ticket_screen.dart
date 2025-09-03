import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';

class DigitalTicketScreen extends StatelessWidget {
  static const routeName = '/ticket';
  final String bookingId;
  const DigitalTicketScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<BookingProvider>().history;
    Booking? booking = history.where((b) => b.id == bookingId).isNotEmpty ? history.firstWhere((b) => b.id == bookingId) : null;
    booking ??= history.isNotEmpty ? history.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Ticket')),
      body: booking == null
          ? const Center(child: Text('Ticket not found'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.confirmation_number, size: 64),
                      const SizedBox(height: 8),
                      Text(booking.event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(booking.event.location),
                      const Divider(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: booking.seats
                            .map((s) => Chip(label: Text('Row ${s.row + 1} • Seat ${s.col + 1}')))
                            .toList(),
                      ),
                      const Spacer(),
                      Text('Booking ID: ${booking.id}', style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Text('Status: ${booking.paymentStatus}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
