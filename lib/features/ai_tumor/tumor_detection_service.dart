import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'tumor_prediction.dart';

/// On-device brain tumor detection service.
///
/// Produces a mock prediction until a model file is placed at
/// `assets/ai/brain_tumor.tflite`. Once the model is placed, it is loaded
/// automatically and real inference is used.
class TumorDetectionService {
  TumorDetectionService._();
  static final TumorDetectionService instance = TumorDetectionService._();

  static const _modelAsset = 'assets/ai/brain_tumor.tflite';
  static const _inputSize = 256;

  Interpreter? _interpreter;
  bool _attemptedLoad = false;
  bool get modelAvailable => _interpreter != null;

  Future<void> ensureLoaded() async {
    if (_attemptedLoad) return;
    _attemptedLoad = true;
    try {
      await rootBundle.load(_modelAsset);
      _interpreter = await Interpreter.fromAsset(_modelAsset);
    } catch (_) {
      _interpreter = null;
    }
  }

  Future<TumorPrediction> predict(File imageFile) async {
    final sw = Stopwatch()..start();
    await ensureLoaded();

    if (_interpreter == null) {
      return _mockPrediction(imageFile, sw);
    }

    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return _mockPrediction(imageFile, sw);
    }
    final resized =
        img.copyResize(decoded, width: _inputSize, height: _inputSize);

    final input = _imageToFloatTensor(resized);
    final output = List.filled(1 * TumorClass.all.length, 0.0)
        .reshape([1, TumorClass.all.length]);

    try {
      _interpreter!.run(input, output);
    } catch (_) {
      return _mockPrediction(imageFile, sw);
    }

    final raw = (output[0] as List).cast<double>();
    final probs = _softmaxIfNeeded(raw);

    final map = <TumorClass, double>{};
    for (var i = 0; i < TumorClass.all.length; i++) {
      map[TumorClass.all[i]] = probs[i];
    }
    final topEntry = map.entries.reduce(
        (a, b) => a.value >= b.value ? a : b);
    sw.stop();

    return TumorPrediction(
      topClass: topEntry.key,
      confidence: topEntry.value,
      probabilities: map,
      usedMock: false,
      inferenceMs: sw.elapsedMilliseconds,
    );
  }

  Future<TumorPrediction> _mockPrediction(
      File imageFile, Stopwatch sw) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final seed = imageFile.path.hashCode;
    final rng = Random(seed);
    final raw = List<double>.generate(
        TumorClass.all.length, (_) => rng.nextDouble());
    final probs = _softmaxIfNeeded(raw);

    final map = <TumorClass, double>{};
    for (var i = 0; i < TumorClass.all.length; i++) {
      map[TumorClass.all[i]] = probs[i];
    }
    final top = map.entries.reduce((a, b) => a.value >= b.value ? a : b);
    sw.stop();

    return TumorPrediction(
      topClass: top.key,
      confidence: top.value,
      probabilities: map,
      usedMock: true,
      inferenceMs: sw.elapsedMilliseconds,
    );
  }

  List<List<List<List<double>>>> _imageToFloatTensor(img.Image image) {
    return [
      List.generate(_inputSize, (y) {
        return List.generate(_inputSize, (x) {
          final pixel = image.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        });
      }),
    ];
  }

  List<double> _softmaxIfNeeded(List<double> values) {
    final sum = values.fold<double>(0, (a, b) => a + b);
    final looksLikeProbs = values.every((v) => v >= 0 && v <= 1) &&
        (sum - 1.0).abs() < 0.05;
    if (looksLikeProbs) return values;
    final maxVal = values.reduce(max);
    final exps = values.map((v) => exp(v - maxVal)).toList();
    final expSum = exps.fold<double>(0, (a, b) => a + b);
    return exps.map((e) => e / expSum).toList();
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _attemptedLoad = false;
  }
}

extension _Reshape on List<double> {
  List<List<double>> reshape(List<int> shape) {
    assert(shape.length == 2 && shape[0] * shape[1] == length);
    final rows = shape[0];
    final cols = shape[1];
    return List.generate(
        rows, (i) => sublist(i * cols, (i + 1) * cols));
  }
}

