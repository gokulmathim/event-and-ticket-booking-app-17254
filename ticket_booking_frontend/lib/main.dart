import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app_theme.dart';
import 'src/navigation/app_router.dart';
import 'src/providers/auth_provider.dart';
import 'src/providers/cart_provider.dart';
import 'src/providers/event_provider.dart';
import 'src/providers/booking_provider.dart';
import 'src/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env'); // optional, used for future API keys
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(prefs: prefs)..restoreSession(),
        ),
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider()..loadInitial(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(prefs: prefs)..loadHistory(),
        ),
      ],
      child: const TicketBookingApp(),
    ),
  );
}

class TicketBookingApp extends StatelessWidget {
  const TicketBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.buildRouter(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket Booker',
      theme: AppTheme.lightTheme,
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: SplashScreen.routeName,
    );
  }
}
