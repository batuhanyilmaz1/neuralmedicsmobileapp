import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_text_field.dart';

class HealthProfileForm extends StatefulWidget {
  const HealthProfileForm({
    super.key,
    required this.onSubmit,
    this.initialAge,
    this.initialGender,
    this.initialWeight,
    this.initialHeight,
    this.initialCalories,
    this.initialBloodType,
    this.submitLabel = 'Kaydet',
    this.showSkip = false,
    this.onSkip,
  });

  final Future<void> Function({
    required int age,
    required String gender,
    required double weightKg,
    required double heightCm,
    int? dailyCaloriesKcal,
    String? bloodType,
  }) onSubmit;

  final int? initialAge;
  final String? initialGender;
  final double? initialWeight;
  final double? initialHeight;
  final int? initialCalories;
  final String? initialBloodType;
  final String submitLabel;
  final bool showSkip;
  final VoidCallback? onSkip;

  @override
  State<HealthProfileForm> createState() => _HealthProfileFormState();
}

class _HealthProfileFormState extends State<HealthProfileForm> {
  static const _genders = ['Erkek', 'Kadın', 'Belirtmek istemiyorum'];
  static const _bloodTypes = [
    'A Rh+',
    'A Rh-',
    'B Rh+',
    'B Rh-',
    'AB Rh+',
    'AB Rh-',
    '0 Rh+',
    '0 Rh-',
  ];

  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _caloriesController;

  String? _gender;
  String? _bloodType;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(
      text: widget.initialAge?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.initialWeight?.toStringAsFixed(1) ?? '',
    );
    _heightController = TextEditingController(
      text: widget.initialHeight?.toStringAsFixed(0) ?? '',
    );
    _caloriesController = TextEditingController(
      text: widget.initialCalories?.toString() ?? '',
    );
    _gender = widget.initialGender;
    _bloodType = widget.initialBloodType;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  int? _parseOptionalInt(String value) {
    if (value.trim().isEmpty) return null;
    return int.tryParse(value.trim());
  }

  Future<void> _submit() async {
    final age = int.tryParse(_ageController.text.trim());
    final weight = double.tryParse(
      _weightController.text.trim().replaceAll(',', '.'),
    );
    final height = double.tryParse(
      _heightController.text.trim().replaceAll(',', '.'),
    );
    final gender = _gender;

    if (age == null || age < 1 || age > 120) {
      _showError('Geçerli bir yaş girin (1–120).');
      return;
    }
    if (gender == null || gender.isEmpty) {
      _showError('Cinsiyet seçin.');
      return;
    }
    if (weight == null || weight < 20 || weight > 300) {
      _showError('Geçerli bir kilo girin (20–300 kg).');
      return;
    }
    if (height == null || height < 80 || height > 250) {
      _showError('Geçerli bir boy girin (80–250 cm).');
      return;
    }

    setState(() => _loading = true);
    try {
      await widget.onSubmit(
        age: age,
        gender: gender,
        weightKg: weight,
        heightCm: height,
        dailyCaloriesKcal: _parseOptionalInt(_caloriesController.text),
        bloodType: _bloodType,
      );
    } catch (e) {
      if (mounted) {
        _showError(AuthService.messageFor(e));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          hint: 'Yaş',
          icon: Icons.cake_outlined,
          keyboardType: TextInputType.number,
          controller: _ageController,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _gender,
          decoration: InputDecoration(
            hintText: 'Cinsiyet',
            prefixIcon: const Icon(Icons.person_outline_rounded),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 24),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          items: _genders
              .map(
                (g) => DropdownMenuItem(
                  value: g,
                  child: Text(g, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _gender = v),
        ),
        const SizedBox(height: 16),
        AppTextField(
          hint: 'Boy (cm)',
          icon: Icons.height_rounded,
          keyboardType: TextInputType.number,
          controller: _heightController,
        ),
        const SizedBox(height: 16),
        AppTextField(
          hint: 'Kilo (kg)',
          icon: Icons.monitor_weight_outlined,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _weightController,
        ),
        const SizedBox(height: 16),
        AppTextField(
          hint: 'Günlük kalori hedefi — isteğe bağlı',
          icon: Icons.local_fire_department_outlined,
          keyboardType: TextInputType.number,
          controller: _caloriesController,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: _bloodType,
          decoration: InputDecoration(
            hintText: 'Kan grubu (isteğe bağlı)',
            prefixIcon: const Icon(Icons.bloodtype_outlined),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 24),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Seçilmedi', overflow: TextOverflow.ellipsis),
            ),
            ..._bloodTypes.map(
              (b) => DropdownMenuItem(
                value: b,
                child: Text(b, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: (v) => setState(() => _bloodType = v),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(widget.submitLabel),
        ),
        if (widget.showSkip) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: _loading ? null : widget.onSkip,
            child: const Text('Şimdilik atla'),
          ),
        ],
      ],
    );
  }
}
