import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/services/prediction_repository.dart';
import '../../core/theme/app_colors.dart';
import 'tumor_detection_service.dart';
import 'tumor_prediction.dart';

class AiTumorScreen extends StatefulWidget {
  const AiTumorScreen({super.key});

  @override
  State<AiTumorScreen> createState() => _AiTumorScreenState();
}

class _AiTumorScreenState extends State<AiTumorScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _analyzing = false;
  TumorPrediction? _result;

  @override
  void initState() {
    super.initState();
    TumorDetectionService.instance.ensureLoaded();
  }

  Future<void> _pick(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, maxWidth: 1024);
    if (picked == null) return;
    setState(() {
      _image = File(picked.path);
      _result = null;
    });
  }

  Future<void> _analyze() async {
    if (_image == null) return;
    setState(() {
      _analyzing = true;
      _result = null;
    });
    try {
      final result =
          await TumorDetectionService.instance.predict(_image!);
      await PredictionRepository.instance.savePrediction(
        prediction: result,
        imagePath: _image!.path,
      );
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        _result = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _analyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('AI Beyin Tümörü Tarama'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AiHeader(),
              const SizedBox(height: 20),
              _ImagePreview(image: _image, analyzing: _analyzing),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _analyzing
                          ? null
                          : () => _pick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Galeriden'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _analyzing
                          ? null
                          : () => _pick(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Kamera'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _image == null || _analyzing ? null : _analyze,
                icon: _analyzing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(_analyzing ? 'Analiz Ediliyor...' : 'Analiz Et'),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      AppColors.primary.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 20),
              if (_result != null) _ResultCard(result: _result!),
              const SizedBox(height: 20),
              const _DisclaimerCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiHeader extends StatelessWidget {
  const _AiHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.profileGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Tarama',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'MR görseli yükleyin, AI ön analiz yapsın.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.image, required this.analyzing});
  final File? image;
  final bool analyzing;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.divider),
        ),
        clipBehavior: Clip.antiAlias,
        child: image == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined,
                        size: 64, color: AppColors.textTertiary),
                    const SizedBox(height: 12),
                    Text(
                      'MR / CT görseli yükleyin',
                      style:
                          TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(image!, fit: BoxFit.cover),
                  if (analyzing)
                    Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(height: 12),
                            Text(
                              'Analiz ediliyor...',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final TumorPrediction result;

  @override
  Widget build(BuildContext context) {
    final top = result.topClass;
    final isTumor = top.isTumor;
    final color = isTumor ? AppColors.danger : AppColors.success;

    final sorted = result.probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isTumor
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(top.label,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18)),
                    const SizedBox(height: 2),
                    Text(
                      '${(result.confidence * 100).toStringAsFixed(1)}% güven · ${result.inferenceMs} ms',
                      style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (result.usedMock)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'DEMO',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            top.description,
            style: TextStyle(
                color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          Text('Tüm sınıflar',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ...sorted.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ProbBar(
                label: e.key.label,
                value: e.value,
                highlighted: e.key == top,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProbBar extends StatelessWidget {
  const _ProbBar({
    required this.label,
    required this.value,
    required this.highlighted,
  });

  final String label;
  final double value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label,
                  style: TextStyle(
                    fontWeight: highlighted
                        ? FontWeight.w800
                        : FontWeight.w600,
                  )),
            ),
            Text('${(value * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: highlighted
                      ? AppColors.primary
                      : AppColors.textSecondary,
                )),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.inputFill,
            valueColor: AlwaysStoppedAnimation(
                highlighted ? AppColors.primary : AppColors.accent),
          ),
        ),
      ],
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Bu sonuçlar tıbbi tanı yerine geçmez. Klinik karar için bir uzman radyolog veya nöroloğa başvurun.',
              style: TextStyle(
                color: AppColors.textPrimary,
                height: 1.4,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
