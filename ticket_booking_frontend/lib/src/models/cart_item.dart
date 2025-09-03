import 'event.dart';
import 'seat.dart';

class CartItem {
  final Event event;
  final List<Seat> seats;

  CartItem({required this.event, required this.seats});

  double get total => event.price * seats.length;
}
