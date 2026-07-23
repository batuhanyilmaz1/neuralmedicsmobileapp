import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import 'health_profile_form.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Health Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete your profile',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your age, height, weight, and other health information are '
                      'used to give more meaningful results in AI analyses. Your '
                      'data is stored only in your own account.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              HealthProfileForm(
                submitLabel: 'Save Profile and Continue',
                onSubmit: ({
                  required age,
                  required gender,
                  required weightKg,
                  required heightCm,
                  dailyCaloriesKcal,
                  bloodType,
                }) async {
                  await AuthService.instance.updateHealthProfile(
                    age: age,
                    gender: gender,
                    weightKg: weightKg,
                    heightCm: heightCm,
                    dailyCaloriesKcal: dailyCaloriesKcal,
                    bloodType: bloodType,
                  );
                  if (context.mounted) context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
