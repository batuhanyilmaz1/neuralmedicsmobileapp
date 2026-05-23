import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:neuralmedicsmobileapp/features/splash/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows app name', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SplashScreen()),
    );

    expect(find.text('NeuralMedics'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });
}
