import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_booking_frontend/main.dart';

void main() {
  testWidgets('App builds without crashing', (tester) async {
    await tester.pumpWidget(const TicketBookingApp());
    expect(find.byType(TicketBookingApp), findsOneWidget);
  });
}
