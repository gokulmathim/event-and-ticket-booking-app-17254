import 'event.dart';
import 'seat.dart';

class Booking {
  final String id;
  final Event event;
  final List<Seat> seats;
  final DateTime createdAt;
  final String paymentStatus; // paid, failed, pending

  Booking({
    required this.id,
    required this.event,
    required this.seats,
    required this.createdAt,
    required this.paymentStatus,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'event': event.toJson(),
        'seats': seats.map((s) => {'id': s.id, 'row': s.row, 'col': s.col}).toList(),
        'createdAt': createdAt.toIso8601String(),
        'paymentStatus': paymentStatus,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'] as String,
        event: Event.fromJson(json['event'] as Map<String, dynamic>),
        seats: (json['seats'] as List<dynamic>)
            .map((e) => Seat(id: e['id'] as String, row: e['row'] as int, col: e['col'] as int, isReserved: true))
            .toList(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        paymentStatus: json['paymentStatus'] as String,
      );
}
