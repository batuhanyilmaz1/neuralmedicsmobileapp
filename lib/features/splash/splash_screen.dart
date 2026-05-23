import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    if (Platform.environment['FLUTTER_TEST'] == 'true') {
      return;
    }

    if (AuthService.instance.isLoggedIn) {
      try {
        await AuthService.instance.loadSessionProfile();
        if (mounted) context.go(AuthService.instance.postAuthRoute);
        return;
      } catch (_) {
        await AuthService.instance.signOut();
      }
    }

    if (mounted) context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MedicsLogo(size: 120, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'NeuralMedics',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicsLogo extends StatelessWidget {
  const _MedicsLogo({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MedicsLogoPainter(color: color)),
    );
  }
}

class _MedicsLogoPainter extends CustomPainter {
  _MedicsLogoPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.32, h * 0.22)
      ..lineTo(w * 0.58, h * 0.22)
      ..quadraticBezierTo(w * 0.78, h * 0.22, w * 0.78, h * 0.40)
      ..quadraticBezierTo(w * 0.78, h * 0.55, w * 0.55, h * 0.55)
      ..lineTo(w * 0.42, h * 0.55)
      ..quadraticBezierTo(w * 0.22, h * 0.55, w * 0.22, h * 0.70)
      ..quadraticBezierTo(w * 0.22, h * 0.85, w * 0.42, h * 0.85)
      ..lineTo(w * 0.68, h * 0.85);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
