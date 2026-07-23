import 'package:flutter/material.dart';

import '../models/health_article.dart';

class HealthArticles {
  HealthArticles._();

  static const List<HealthArticle> all = [
    HealthArticle(
      id: 'beyin-tumoru-belirtileri',
      title: 'Early signs of brain tumors: what should you watch for?',
      category: 'Neurology',
      readMinutes: 6,
      icon: Icons.psychology_alt_outlined,
      summary:
          'Early evaluation is important when symptoms like headaches, vision problems, and loss of balance appear.',
      paragraphs: [
        'Brain tumors can arise from abnormal cell growth in or around brain tissue. Not every headache means a tumor; however, headaches that grow progressively worse, are more pronounced in the morning, or don\'t respond to standard painkillers should be monitored closely.',
        'Blurred vision, double vision, hearing loss, speech difficulty, one-sided weakness, and balance problems may require a neurological evaluation. These symptoms alone are not diagnostic, but together they provide important clues for a clinician.',
        'Seizures, personality changes, memory problems, or persistent nausea are also among the warning signs. New-onset, progressively worsening seizures in particular require urgent medical evaluation.',
        'NeuralMedics offers an AI-assisted preliminary analysis of MRI images. These results are not a substitute for diagnosis, but they can raise risk awareness before you speak with your doctor. If you have any concerning symptoms, be sure to consult a neurologist or radiologist.',
      ],
    ),
    HealthArticle(
      id: 'beslenme-beyin-sagligi',
      title: 'Nutrition habits that support brain health',
      category: 'Nutrition',
      readMinutes: 5,
      icon: Icons.eco_outlined,
      summary:
          'Omega-3s, antioxidants, and adequate hydration can support brain function.',
      paragraphs: [
        'The brain is one of the body\'s most energy-intensive organs. A balanced diet can have a positive effect on focus, memory, and overall cognitive performance.',
        'Omega-3 fatty acids (fish, walnuts, flaxseed), antioxidant-rich fruits and vegetables (blueberries, spinach, broccoli), and whole grains are commonly recommended for brain health. Limiting processed food, excess sugar, and saturated fat is beneficial for overall health.',
        'Drinking enough water each day can help reduce fatigue and loss of concentration. Balancing caffeine intake according to your personal tolerance is also important.',
        'A healthy diet alone cannot replace medical treatment. If you have a chronic condition or take medication, always build your nutrition plan together with your doctor.',
      ],
    ),
    HealthArticle(
      id: 'mr-goruntuleme-nedir',
      title: 'What is MRI and when is it needed?',
      category: 'Radiology',
      readMinutes: 4,
      icon: Icons.medical_information_outlined,
      summary:
          'Magnetic resonance imaging is a radiation-free method that shows soft tissues in high resolution.',
      paragraphs: [
        'Magnetic Resonance Imaging (MRI) uses a strong magnetic field and radio waves to create detailed images of the brain, spinal cord, and other soft tissues. No ionizing radiation is used during the procedure.',
        'Brain MRI is frequently preferred when stroke, tumor, infection, demyelinating disease, or trauma is suspected. Contrast agent (gadolinium) may be used in some cases to make it easier to distinguish lesions.',
        'An MRI scan usually takes 20–45 minutes. The patient must remain still; you should inform your doctor if you have claustrophobia or a metal implant.',
        'NeuralMedics only provides decision-support analysis on your existing MRI images. The imaging decision and its interpretation must always be made by a qualified radiologist.',
      ],
    ),
    HealthArticle(
      id: 'yapay-zeka-karar-destek',
      title: 'AI-assisted medical decision support systems',
      category: 'Technology',
      readMinutes: 7,
      icon: Icons.smart_toy_outlined,
      summary:
          'AI systems provide extra information to doctors and patients; the diagnosis and treatment decision is made by the doctor.',
      paragraphs: [
        'Clinical decision support systems (CDSS) can analyze clinical data to provide doctors with risk assessment, prioritization, and second-opinion support. AI models learn from large datasets to develop pattern-recognition capabilities.',
        'NeuralMedics generates probability scores for four classes (glioma, meningioma, pituitary, no tumor) on brain MRI images. Results are stored on your local device; your profile information is kept in a secure cloud environment.',
        'AI models do not guarantee 100% accuracy. False positive or false negative results are possible. For this reason, our system is positioned as "decision support"; the final clinical decision must be made by a doctor.',
        'The age, weight, height, and other information in your health profile may be used in the future to enrich the analysis context. Your data is stored only under your own account.',
      ],
    ),
    HealthArticle(
      id: 'norolojik-muayene-oncesi',
      title: 'What to know before a neurological examination',
      category: 'Guide',
      readMinutes: 4,
      icon: Icons.assignment_outlined,
      summary:
          'Preparing for your appointment can lead to a more accurate evaluation and save time.',
      paragraphs: [
        'Before your neurologist appointment, note your symptoms chronologically: when they started, how they progressed, and whether there are any triggers. Bring any previous MRI/CT reports with you if possible.',
        'Bringing a written list of the medications you take, your allergies, and any past surgeries speeds up the examination. Mention it if there is a family history of similar neurological conditions.',
        'You can share your latest analysis results from your NeuralMedics scan history with your doctor. This can provide extra context during the consultation, but it does not replace official reports.',
        'If you have emergency symptoms (sudden signs of stroke, severe headache, loss of consciousness, seizure), do not wait for an appointment; call emergency services or go to the nearest emergency room.',
      ],
    ),
  ];

  static HealthArticle? byId(String id) {
    for (final article in all) {
      if (article.id == id) return article;
    }
    return null;
  }

  static List<HealthArticle> get featured => all.take(2).toList();
}
