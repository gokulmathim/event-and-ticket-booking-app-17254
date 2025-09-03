import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../models/seat.dart';
import '../../providers/cart_provider.dart';
import '../../providers/event_provider.dart';
import '../../services/event_service.dart';
import 'cart_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  static const routeName = '/booking/seats';
  final String eventId;
  const SeatSelectionScreen({super.key, required this.eventId});

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final _service = EventService();
  List<Seat> _seats = <Seat>[];
  final Set<String> _selected = <String>{};
  Event? _event;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final event = context.read<EventProvider>().events.firstWhere((e) => e.id == widget.eventId);
    final seats = await _service.seats(widget.eventId);
    setState(() {
      _event = event;
      _seats = seats;
      _loading = false;
    });
  }

  void _toggle(Seat seat) {
    if (seat.isReserved) return;
    setState(() {
      if (_selected.contains(seat.id)) {
        _selected.remove(seat.id);
      } else {
        _selected.add(seat.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _event == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final event = _event!;
    final rows = event.rows;
    final cols = event.cols;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Seats')),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: cols / rows,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemCount: _seats.length,
                  itemBuilder: (_, i) {
                    final seat = _seats[i];
                    final selected = _selected.contains(seat.id);
                    final color = seat.isReserved
                        ? Colors.grey.shade300
                        : selected
                            ? Colors.green
                            : Colors.blue.shade100;
                    return GestureDetector(
                      onTap: () => _toggle(seat),
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: selected ? Colors.green.shade700 : Colors.black12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selected.isEmpty
                        ? null
                        : () {
                            final selectedSeats = _seats.where((s) => _selected.contains(s.id)).toList();
                            context.read<CartProvider>().add(event, selectedSeats);
                            Navigator.of(context).pushNamed(CartScreen.routeName);
                          },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: Text(_selected.isEmpty ? 'Select seats' : 'Add ${_selected.length} to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
