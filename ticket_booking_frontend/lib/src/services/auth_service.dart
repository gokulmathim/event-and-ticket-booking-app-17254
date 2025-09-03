import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  final SharedPreferences prefs;
  AuthService(this.prefs);

  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user_email';
  static const _keyName = 'auth_user_name';
  static const _keyId = 'auth_user_id';

  // PUBLIC_INTERFACE
  Future<User?> login(String email, String password) async {
    /** Simulated login. Returns a user and stores token to preferences. */
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (email.isEmpty || password.isEmpty) return null;

    final user = User(id: email.hashCode.toString(), email: email, name: email.split('@').first);
    await prefs.setString(_keyToken, 'mock_token_${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setString(_keyUser, user.email);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyId, user.id);
    return user;
  }

  // PUBLIC_INTERFACE
  Future<User?> register(String name, String email, String password) async {
    /** Simulated registration. */
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return login(email, password);
  }

  // PUBLIC_INTERFACE
  User? restoreSession() {
    /** Attempts to restore a user session from preferences. */
    final token = prefs.getString(_keyToken);
    final email = prefs.getString(_keyUser);
    final name = prefs.getString(_keyName);
    final id = prefs.getString(_keyId);
    if (token != null && email != null && name != null && id != null) {
      return User(id: id, email: email, name: name);
    }
    return null;
  }

  // PUBLIC_INTERFACE
  Future<void> logout() async {
    /** Clears the stored session. */
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.remove(_keyName);
    await prefs.remove(_keyId);
  }
}
