import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _items = [
    _FaqItem(
      question: 'NeuralMedics nedir?',
      answer:
          'NeuralMedics, beyin MR görüntülerinde yapay zeka destekli ön analiz sunan '
          'bir karar destek sistemidir. Tanı koymaz; hekiminize ek bilgi sağlar.',
    ),
    _FaqItem(
      question: 'Sonuçlar ne kadar güvenilir?',
      answer:
          'Model eğitim verisine bağlı olarak değişir. Yanlış pozitif veya negatif '
          'sonuçlar mümkündür. Nihai değerlendirme mutlaka uzman hekim tarafından yapılmalıdır.',
    ),
    _FaqItem(
      question: 'Verilerim nerede saklanır?',
      answer:
          'Profil bilgileriniz Firebase Firestore\'da, tarama geçmişiniz ise yalnızca '
          'cihazınızdaki yerel veritabanında saklanır.',
    ),
    _FaqItem(
      question: 'Sağlık profilim neden gerekli?',
      answer:
          'Yaş, boy, kilo gibi bilgiler analiz bağlamını zenginleştirir ve profil '
          'ekranınızdaki sağlık göstergelerini kişiselleştirir.',
    ),
    _FaqItem(
      question: 'DEMO etiketi ne anlama geliyor?',
      answer:
          'AI model dosyası cihazda yüklü değilse sistem demo modunda çalışır. '
          'Gerçek model entegrasyonu için assets/ai/brain_tumor.tflite dosyası gerekir.',
    ),
    _FaqItem(
      question: 'Şifremi nasıl sıfırlarım?',
      answer:
          'Giriş ekranındaki "Şifremi Unuttum" bağlantısını veya profildeki '
          '"Şifre Sıfırla" seçeneğini kullanın. E-posta adresinize sıfırlama '
          'bağlantısı gönderilir.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Sıkça Sorulan Sorular'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) {
          final item = _items[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  item.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.answer,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});
  final String question;
  final String answer;
}
