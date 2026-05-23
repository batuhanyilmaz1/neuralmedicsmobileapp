import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import 'health_profile_form.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      await AuthService.instance.loadSessionProfile();
    } catch (_) {}
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profile = AuthService.instance.profile;
    final bmi = profile?.bmi;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Sağlık Profilim'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (bmi != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.analytics_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'VKİ: ${bmi.toStringAsFixed(1)} kg/m²',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              HealthProfileForm(
                submitLabel: 'Güncelle',
                initialAge: profile?.age,
                initialGender: profile?.gender,
                initialWeight: profile?.weightKg,
                initialHeight: profile?.heightCm,
                initialCalories: profile?.dailyCaloriesKcal,
                initialBloodType: profile?.bloodType,
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
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sağlık profiliniz güncellendi.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
