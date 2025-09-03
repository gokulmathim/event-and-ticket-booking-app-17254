# ticket_booking_frontend

Mobile frontend for browsing, booking, and managing event tickets. Features include:
- User registration/login
- Browse, search, and filter events
- Seat selection
- Add to cart
- Checkout and Stripe-ready payment service (mocked)
- Booking confirmation and digital ticket
- Booking history
- Profile management

## Run
- flutter pub get
- flutter run

## Environment variables
Create `.env` (optional, used for future Stripe integration):
```
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
```

## Notes
- PaymentService is mocked to avoid external dependencies. When ready to integrate Stripe, add a Stripe Flutter package, supply the publishable key via `.env`, and replace PaymentService.pay with real calls.
- Booking history is stored locally using SharedPreferences for demo purposes.
