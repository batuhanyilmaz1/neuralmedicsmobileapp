import 'package:flutter/foundation.dart';

/// Host for Firebase emulators (Auth + SQL Connect).
/// Android emulator uses 10.0.2.2 to reach the host machine.
String get firebaseEmulatorHost {
  if (kIsWeb) return 'localhost';
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return '10.0.2.2';
    default:
      return '127.0.0.1';
  }
}

const int authEmulatorPort = 9099;
const int dataConnectEmulatorPort = 9399;
