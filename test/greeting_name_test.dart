import 'package:flutter_test/flutter_test.dart';
import 'package:neuralmedicsmobileapp/core/utils/greeting_name.dart';

void main() {
  test('uses first word of full name', () {
    expect(greetingFirstName('Ayşe Yılmaz'), 'Ayşe');
  });

  test('uses local part when display name is an email', () {
    expect(greetingFirstName('batuhan@example.com'), 'batuhan');
  });

  test('falls back when empty', () {
    expect(greetingFirstName(''), 'Kullanıcı');
    expect(greetingFirstName('   '), 'Kullanıcı');
  });
}
