import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import '../ticket/digital_ticket_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<BookingProvider>().history;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking History')),
      body: history.isEmpty
          ? const Center(child: Text('No bookings yet'))
          : ListView.separated(
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) => _BookingTile(booking: history[i]),
            ),
    );
  }
}

class _BookingTile extends StatelessWidget {
  final Booking booking;
  const _BookingTile({required this.booking});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.event_available),
      title: Text(booking.event.title),
      subtitle: Text('${booking.seats.length} seats • ${booking.createdAt}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).pushNamed(DigitalTicketScreen.routeName, arguments: booking.id),
    );
  }
}
