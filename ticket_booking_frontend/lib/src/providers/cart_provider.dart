import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/event.dart';
import '../models/seat.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = <CartItem>[];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0, (sum, i) => sum + i.total);

  // PUBLIC_INTERFACE
  void add(Event event, List<Seat> seats) {
    /** Adds seats for an event to the cart (merging by event). */
    final existingIndex = _items.indexWhere((i) => i.event.id == event.id);
    if (existingIndex >= 0) {
      final existing = _items[existingIndex];
      final merged = <Seat>[...existing.seats];
      for (final s in seats) {
        if (!merged.any((m) => m.id == s.id)) merged.add(s);
      }
      _items[existingIndex] = CartItem(event: event, seats: merged);
    } else {
      _items.add(CartItem(event: event, seats: seats));
    }
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  void remove(String eventId, String seatId) {
    /** Removes a specific seat from cart. */
    final idx = _items.indexWhere((i) => i.event.id == eventId);
    if (idx < 0) return;
    final item = _items[idx];
    final left = item.seats.where((s) => s.id != seatId).toList();
    if (left.isEmpty) {
      _items.removeAt(idx);
    } else {
      _items[idx] = CartItem(event: item.event, seats: left);
    }
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  void clear() {
    /** Empties the cart. */
    _items.clear();
    notifyListeners();
  }
}
