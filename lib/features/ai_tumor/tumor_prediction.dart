class TumorClass {
  const TumorClass({
    required this.id,
    required this.label,
    required this.description,
    required this.isTumor,
  });

  final String id;
  final String label;
  final String description;
  final bool isTumor;

  static const glioma = TumorClass(
    id: 'glioma',
    label: 'Glioma',
    description:
        'A tumor originating from glial cells. It can be high-grade; specialist evaluation is required.',
    isTumor: true,
  );

  static const meningioma = TumorClass(
    id: 'meningioma',
    label: 'Meningioma',
    description:
        'Develops from the membranes surrounding the brain, mostly benign but may cause symptoms depending on its location.',
    isTumor: true,
  );

  static const pituitary = TumorClass(
    id: 'pituitary',
    label: 'Pituitary',
    description:
        'A tumor originating from the pituitary gland. It may affect hormonal balance and requires follow-up.',
    isTumor: true,
  );

  static const noTumor = TumorClass(
    id: 'notumor',
    label: 'No Tumor',
    description:
        'No signs of a tumor were detected in the image. Consult a specialist if clinical suspicion persists.',
    isTumor: false,
  );

  static const all = [glioma, meningioma, noTumor, pituitary];
}

class TumorPrediction {
  const TumorPrediction({
    required this.topClass,
    required this.confidence,
    required this.probabilities,
    required this.usedMock,
    required this.inferenceMs,
  });

  final TumorClass topClass;
  final double confidence;
  final Map<TumorClass, double> probabilities;
  final bool usedMock;
  final int inferenceMs;
}
