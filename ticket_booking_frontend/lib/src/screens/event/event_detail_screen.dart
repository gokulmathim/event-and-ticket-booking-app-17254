import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';
import '../booking/seat_selection_screen.dart';

class EventDetailScreen extends StatelessWidget {
  static const routeName = '/event/detail';
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final event = context.select<EventProvider, Event?>(
      (p) => p.events.firstWhere((e) => e.id == eventId, orElse: () => const Event(
        id: '_', title: '', description: '', location: '', dateTime: DateTime(2000), price: 0, imageUrl: '',
      )),
    );
    if (event == null || event.id == '_') {
      return const Scaffold(body: Center(child: Text('Event not found')));
    }
    final df = DateFormat('EEEE, MMM d, y • h:mm a');

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(SeatSelectionScreen.routeName, arguments: {'eventId': event.id});
        },
        icon: const Icon(Icons.event_seat),
        label: const Text('Select Seats'),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(event.imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(event.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.place_outlined, size: 18),
                const SizedBox(width: 6),
                Text(event.location),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.event, size: 18),
                const SizedBox(width: 6),
                Text(df.format(event.dateTime)),
              ]),
              const SizedBox(height: 12),
              Text(event.description),
              const SizedBox(height: 16),
              Text('\$${event.price.toStringAsFixed(2)} per seat',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 80),
            ]),
          )
        ],
      ),
    );
  }
}
