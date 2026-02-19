import 'package:get_it/get_it.dart';

import '../session/user_session.dart';
import '../session/session_resource.dart';

final _getIt = GetIt.instance;

class SessionScope {
  /// Starts a new user session scope and registers session-scoped dependencies.
  static Future<void> startSession(String userId) async {
    // pushNewScope is synchronous; don't await a void value
    _getIt.pushNewScope(init: (_) {
      // Register a simple UserSession in the scope
      _getIt.registerSingleton<UserSession>(UserSession(userId: userId));
      // Example session resource that should be disposed when session ends
      _getIt.registerSingleton<SessionResource>(SessionResource('user-res'));
      // Register any session-scoped resources here
    });
  }

  /// Ends the current session and disposes scoped resources.
  static Future<void> endSession() async {
    try {
      // If a UserSession implements dispose, call it before popping scope
      if (_getIt.isRegistered<SessionResource>()) {
        try {
          _getIt<SessionResource>().dispose();
        } catch (_) {}
      }
      if (_getIt.isRegistered<UserSession>()) {
        final session = _getIt<UserSession>();
        session.dispose();
      }
    } catch (_) {}
    _getIt.popScope();
  }

  static bool get hasSession => _getIt.isRegistered<UserSession>();

  static UserSession? get currentSession =>
      _getIt.isRegistered<UserSession>() ? _getIt<UserSession>() : null;
}
