import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/google_sign_in_config.dart';
import 'core/database/prediction_database.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb) {
    await GoogleSignIn.instance.initialize(
      serverClientId: GoogleSignInConfig.serverClientId,
    );
  }
  await initializeDateFormatting('en_US', null);
  await PredictionDatabase.instance.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const NeuralMedicsApp());
}

class NeuralMedicsApp extends StatelessWidget {
  const NeuralMedicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NeuralMedics',
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
