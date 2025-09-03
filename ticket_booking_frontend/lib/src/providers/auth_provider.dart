import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  late final AuthService _service;

  User? _user;
  bool _loading = false;

  AuthProvider({required this.prefs}) {
    _service = AuthService(prefs);
  }

  User? get user => _user;
  bool get isLoading => _loading;
  bool get isAuthenticated => _user != null;

  // PUBLIC_INTERFACE
  void restoreSession() {
    /** Tries to restore a saved session on app start. */
    _user = _service.restoreSession();
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<bool> login(String email, String password) async {
    /** Logs in user. */
    _loading = true;
    notifyListeners();
    final u = await _service.login(email, password);
    _user = u;
    _loading = false;
    notifyListeners();
    return _user != null;
  }

  // PUBLIC_INTERFACE
  Future<bool> register(String name, String email, String password) async {
    /** Registers user. */
    _loading = true;
    notifyListeners();
    final u = await _service.register(name, email, password);
    _user = u;
    _loading = false;
    notifyListeners();
    return _user != null;
  }

  // PUBLIC_INTERFACE
  Future<void> logout() async {
    /** Logs out user and clears session. */
    await _service.logout();
    _user = null;
    notifyListeners();
  }

  // PUBLIC_INTERFACE
  Future<void> updateProfile({required String name}) async {
    /** Updates profile locally (demo). */
    if (_user == null) return;
    _user = User(id: _user!.id, email: _user!.email, name: name);
    notifyListeners();
  }
}
