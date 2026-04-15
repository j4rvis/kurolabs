import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  const AuthService();

  static final _auth = Supabase.instance.client.auth;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  User? get currentUser => _auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? username,
    String? displayName,
  }) async {
    return _auth.signUp(
      email: email,
      password: password,
      data: {
        if (username != null) 'username': username,
        if (displayName != null) 'display_name': displayName,
      },
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }
}
