import 'dart:math';
import '../models/event.dart';
import '../models/seat.dart';

class EventService {
  final List<Event> _events = List<Event>.generate(14, (i) {
    final dt = DateTime.now().add(Duration(days: i));
    return Event(
      id: 'evt_$i',
      title: 'Concert #$i',
      description: 'Experience an unforgettable evening with Concert #$i. '
          'Join us for live music, lights, and vibes.',
      location: 'Arena ${i + 1}, City',
      dateTime: dt,
      price: 24.99 + i,
      imageUrl: 'https://picsum.photos/seed/event$i/800/450',
      rows: 8 + (i % 4),
      cols: 10 + (i % 6),
    );
  });

  // PUBLIC_INTERFACE
  Future<List<Event>> listEvents({String? query, String? location}) async {
    /** Returns event list filtered by query and location. */
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _events.where((e) {
      final q = (query ?? '').toLowerCase();
      final l = (location ?? '').toLowerCase();
      final okQ = q.isEmpty || e.title.toLowerCase().contains(q) || e.description.toLowerCase().contains(q);
      final okL = l.isEmpty || e.location.toLowerCase().contains(l);
      return okQ && okL;
    }).toList();
  }

  // PUBLIC_INTERFACE
  Future<Event?> getEvent(String id) async {
    /** Gets event detail by id. */
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _events.where((e) => e.id == id).firstOrNull;
  }

  // PUBLIC_INTERFACE
  Future<List<Seat>> seats(String eventId) async {
    /** Generates a mock seat map for the event with some reserved seats. */
    final event = await getEvent(eventId);
    if (event == null) return [];
    final rand = Random(event.id.hashCode);
    final list = <Seat>[];
    for (var r = 0; r < event.rows; r++) {
      for (var c = 0; c < event.cols; c++) {
        final reserved = rand.nextDouble() < 0.15; // 15% reserved
        list.add(Seat(id: '${event.id}_$r:$c', row: r, col: c, isReserved: reserved));
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return list;
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
