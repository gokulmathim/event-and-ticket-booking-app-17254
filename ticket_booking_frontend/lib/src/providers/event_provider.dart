import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  final _service = EventService();

  List<Event> _events = <Event>[];
  bool _loading = false;
  String _query = '';
  String _location = '';

  List<Event> get events => _events;
  bool get isLoading => _loading;
  String get query => _query;
  String get location => _location;

  // PUBLIC_INTERFACE
  Future<void> loadInitial() async {
    /** Loads initial events. */
    _loading = true;
    notifyListeners();
    _events = await _service.listEvents();
    _loading = false;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> search({String? query, String? location}) async {
    /** Searches events with filters. */
    _query = query ?? _query;
    _location = location ?? _location;
    _loading = true;
    notifyListeners();
    _events = await _service.listEvents(query: _query, location: _location);
    _loading = false;
    notifyListeners();
  }
}
