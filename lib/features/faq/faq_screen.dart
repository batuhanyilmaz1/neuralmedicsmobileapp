import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _items = [
    _FaqItem(
      question: 'What is NeuralMedics?',
      answer:
          'NeuralMedics is a decision support system that offers AI-assisted '
          'preliminary analysis of brain MRI images. It does not provide a diagnosis; it gives your doctor extra information.',
    ),
    _FaqItem(
      question: 'How reliable are the results?',
      answer:
          'This depends on the model\'s training data. False positive or negative '
          'results are possible. The final evaluation must always be made by a qualified physician.',
    ),
    _FaqItem(
      question: 'Where is my data stored?',
      answer:
          'Your profile information is stored in Firebase Firestore, while your '
          'scan history is stored only in the local database on your device.',
    ),
    _FaqItem(
      question: 'Why is my health profile needed?',
      answer:
          'Information such as age, height, and weight enriches the analysis context and '
          'personalizes the health indicators on your profile screen.',
    ),
    _FaqItem(
      question: 'What does the DEMO label mean?',
      answer:
          'If the AI model file is not installed on the device, the system runs in demo mode. '
          'For real model integration, the assets/ai/brain_tumor.tflite file is required.',
    ),
    _FaqItem(
      question: 'How do I reset my password?',
      answer:
          'Use the "Forgot Password" link on the login screen or the '
          '"Reset Password" option in your profile. A reset '
          'link will be sent to your email address.',
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
        title: const Text('Frequently Asked Questions'),
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
