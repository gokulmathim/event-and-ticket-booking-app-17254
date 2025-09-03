import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_shell.dart';
import '../screens/splash_screen.dart';
import '../screens/event/event_detail_screen.dart';
import '../screens/booking/seat_selection_screen.dart';
import '../screens/booking/cart_screen.dart';
import '../screens/booking/checkout_screen.dart';
import '../screens/booking/confirmation_screen.dart';
import '../screens/ticket/digital_ticket_screen.dart';

class AppRouter {
  const AppRouter();

  // PUBLIC_INTERFACE
  RouteFactory get onGenerateRoute {
    /** Returns the route generator for the app. */
    return (RouteSettings settings) {
      final args = settings.arguments;
      switch (settings.name) {
        case SplashScreen.routeName:
          return _material(const SplashScreen());
        case LoginScreen.routeName:
          return _material(const LoginScreen());
        case RegisterScreen.routeName:
          return _material(const RegisterScreen());
        case HomeShell.routeName:
          return _material(const HomeShell());
        case EventDetailScreen.routeName:
          return _material(EventDetailScreen(eventId: args as String));
        case SeatSelectionScreen.routeName:
          final map = args as Map<String, dynamic>;
          return _material(SeatSelectionScreen(eventId: map['eventId'] as String));
        case CartScreen.routeName:
          return _material(const CartScreen());
        case CheckoutScreen.routeName:
          return _material(const CheckoutScreen());
        case ConfirmationScreen.routeName:
          final bookingId = args as String;
          return _material(ConfirmationScreen(bookingId: bookingId));
        case DigitalTicketScreen.routeName:
          final bookingId = args as String;
          return _material(DigitalTicketScreen(bookingId: bookingId));
        default:
          return _material(const SplashScreen());
      }
    };
  }

  // PUBLIC_INTERFACE
  static AppRouter buildRouter(BuildContext context) {
    /** Factory to build router instance if needed for DI in future. */
    return const AppRouter();
  }

  static MaterialPageRoute _material(Widget child) =>
      MaterialPageRoute(builder: (_) => child);
}
