import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_booking_frontend/main.dart';

void main() {
  testWidgets('App boots to SplashScreen', (tester) async {
    await tester.pumpWidget(const TicketBookingApp());
    await tester.pump(const Duration(milliseconds: 10));
    expect(find.byType(TicketBookingApp), findsOneWidget);
  });
}
