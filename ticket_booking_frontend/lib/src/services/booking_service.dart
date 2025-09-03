import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';

class BookingService {
  final SharedPreferences prefs;
  BookingService(this.prefs);

  static const _historyKey = 'booking_history';

  // PUBLIC_INTERFACE
  List<Booking> loadHistory() {
    /** Loads persisted booking history from local storage. */
    final raw = prefs.getStringList(_historyKey) ?? <String>[];
    return raw.map((e) => Booking.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // PUBLIC_INTERFACE
  Future<void> addToHistory(Booking booking) async {
    /** Adds a booking to history and persists. */
    final list = prefs.getStringList(_historyKey) ?? <String>[];
    list.add(jsonEncode(booking.toJson()));
    await prefs.setStringList(_historyKey, list);
  }

  // PUBLIC_INTERFACE
  Future<void> clear() async {
    /** Clears booking history. */
    await prefs.remove(_historyKey);
  }
}
