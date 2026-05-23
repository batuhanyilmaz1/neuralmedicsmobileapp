import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

/// Notifies [GoRouter] when Firebase Auth session changes.
class AuthRefreshListenable extends ChangeNotifier {
  AuthRefreshListenable() {
    _subscription = AuthService.instance.authStateChanges.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authRefreshListenable = AuthRefreshListenable();
