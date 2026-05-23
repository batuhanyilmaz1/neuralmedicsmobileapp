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
        'Glial hücrelerden köken alan tümör. Yüksek dereceli olabilir; uzman görüşü zorunludur.',
    isTumor: true,
  );

  static const meningioma = TumorClass(
    id: 'meningioma',
    label: 'Meningioma',
    description:
        'Beyin zarlarından gelişir, çoğunlukla iyi huyludur ancak yerleşimine göre semptom verir.',
    isTumor: true,
  );

  static const pituitary = TumorClass(
    id: 'pituitary',
    label: 'Pituitary',
    description:
        'Hipofiz bezi kaynaklı tümör. Hormonal dengeyi etkileyebilir, takip gerektirir.',
    isTumor: true,
  );

  static const noTumor = TumorClass(
    id: 'notumor',
    label: 'No Tumor',
    description:
        'Görüntüde tümör belirtisi tespit edilmedi. Klinik şüphe sürerse uzmana danışın.',
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
