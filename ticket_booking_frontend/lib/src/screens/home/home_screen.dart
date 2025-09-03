import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../event/event_detail_screen.dart';
import '../../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _query = TextEditingController();
  final _location = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    _location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventProvider>();
    final events = prov.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Events'),
      ),
      body: Column(
        children: [
          _buildSearch(context),
          Expanded(
            child: prov.isLoading
                ? const Loading(message: 'Loading events...')
                : events.isEmpty
                    ? const Empty(title: 'No events found')
                    : ListView.separated(
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        padding: const EdgeInsets.all(12),
                        itemBuilder: (_, i) => _EventCard(event: events[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    final prov = context.read<EventProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _query,
              decoration: const InputDecoration(
                hintText: 'Search events, artists...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => prov.search(query: _query.text.trim(), location: _location.text.trim()),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _location,
              decoration: const InputDecoration(
                hintText: 'Location',
                prefixIcon: Icon(Icons.place_outlined),
              ),
              onSubmitted: (_) => prov.search(query: _query.text.trim(), location: _location.text.trim()),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => prov.search(query: _query.text.trim(), location: _location.text.trim()),
            child: const Icon(Icons.tune),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('EEE, MMM d • h:mm a');
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(EventDetailScreen.routeName, arguments: event.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(event.imageUrl, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(event.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text(event.location, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16),
                    const SizedBox(width: 4),
                    Text(df.format(event.dateTime)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('\$${event.price.toStringAsFixed(2)} / seat',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
