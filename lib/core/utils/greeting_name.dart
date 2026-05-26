/// Returns a short, friendly name for greetings (e.g. home header).
String greetingFirstName(String displayName) {
  final source = displayName.trim();
  if (source.isEmpty) return 'Kullanıcı';
  if (source.contains('@')) {
    return source.split('@').first;
  }
  return source.split(RegExp(r'\s+')).first;
}
