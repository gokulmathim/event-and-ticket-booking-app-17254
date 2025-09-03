import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';
import '../models/cart_item.dart';
import '../services/booking_service.dart';
import '../services/payment_service.dart';

class BookingProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  late final BookingService _bookingService;
  late final PaymentService _paymentService;

  List<Booking> _history = <Booking>[];
  bool _processing = false;
  String? _lastPaymentId;

  BookingProvider({required this.prefs}) {
    _bookingService = BookingService(prefs);
    _paymentService = PaymentService(stripePublishableKey: dotenv.env['STRIPE_PUBLISHABLE_KEY']);
  }

  List<Booking> get history => _history;
  bool get isProcessing => _processing;
  String? get lastPaymentId => _lastPaymentId;

  // PUBLIC_INTERFACE
  void loadHistory() {
    /** Loads history from local storage. */
    _history = _bookingService.loadHistory();
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<String?> checkout(List<CartItem> items) async {
    /** Performs a mock checkout/payment and persists booking. Returns booking id. */
    if (items.isEmpty) return null;
    _processing = true;
    _lastPaymentId = null;
    notifyListeners();

    final amount = items.fold<double>(0, (s, i) => s + i.total);
    try {
      final paymentId = await _paymentService.pay(
        amount: amount,
        currency: 'usd',
        description: 'Tickets purchase',
      );
      _lastPaymentId = paymentId;

      // Persist each event as a booking
      for (final item in items) {
        final booking = Booking(
          id: '${DateTime.now().millisecondsSinceEpoch}_${item.event.id}',
          event: item.event,
          seats: item.seats,
          createdAt: DateTime.now(),
          paymentStatus: 'paid',
        );
        await _bookingService.addToHistory(booking);
        _history.insert(0, booking);
      }
      _processing = false;
      notifyListeners();
      return _history.first.id;
    } catch (_) {
      _processing = false;
      notifyListeners();
      return null;
    }
  }
}
