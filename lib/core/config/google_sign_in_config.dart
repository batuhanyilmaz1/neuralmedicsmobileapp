/// OAuth client IDs from Firebase `google-services.json` / `GoogleService-Info.plist`.
class GoogleSignInConfig {
  GoogleSignInConfig._();

  /// Web client (client_type 3) — required for Firebase Auth id tokens on Android.
  static const String serverClientId =
      '881972389573-cvt79k6g2roikrn9801jl13dop4ea32o.apps.googleusercontent.com';

  /// iOS client — only needed when not using `GoogleService-Info.plist`.
  static const String iosClientId =
      '881972389573-ioe48s7vrckk3fgbtd8tk663qkkaonq7.apps.googleusercontent.com';
}
