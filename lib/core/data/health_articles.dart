import 'package:flutter/material.dart';

import '../models/health_article.dart';

class HealthArticles {
  HealthArticles._();

  static const List<HealthArticle> all = [
    HealthArticle(
      id: 'beyin-tumoru-belirtileri',
      title: 'Beyin tümörlerinin erken belirtileri: nelere dikkat etmelisiniz?',
      category: 'Nöroloji',
      readMinutes: 6,
      icon: Icons.psychology_alt_outlined,
      summary:
          'Baş ağrısı, görme bozuklukları ve denge kaybı gibi belirtiler fark edildiğinde erken değerlendirme önemlidir.',
      paragraphs: [
        'Beyin tümörleri, beyin dokusunda veya çevresinde anormal hücre büyümesiyle ortaya çıkabilir. Her baş ağrısı tümör anlamına gelmez; ancak giderek artan şiddette, sabahları daha belirgin olan veya standart ağrı kesicilere yanıt vermeyen baş ağrıları dikkatle izlenmelidir.',
        'Görme bulanıklığı, çift görme, işitme kaybı, konuşma güçlüğü, tek taraflı güçsüzlük ve denge bozuklukları nörolojik değerlendirme gerektirebilir. Bu belirtiler tek başına tanı koydurmaz; birlikte değerlendirildiğinde klinisyen için önemli ipuçları sunar.',
        'Nöbet, kişilik değişikliği, hafıza sorunları veya sürekli mide bulantısı da uyarı işaretleri arasında sayılabilir. Özellikle yeni başlayan ve giderek kötüleşen nöbetler acil tıbbi değerlendirme gerektirir.',
        'NeuralMedics, MR görüntülerinde yapay zeka destekli ön analiz sunar. Bu sonuçlar tanı yerine geçmez; ancak hekiminizle görüşmeden önce risk farkındalığını artırabilir. Şüpheli belirti varsa mutlaka bir nörolog veya radyolog ile görüşün.',
      ],
    ),
    HealthArticle(
      id: 'beslenme-beyin-sagligi',
      title: 'Beyin sağlığını destekleyen beslenme alışkanlıkları',
      category: 'Beslenme',
      readMinutes: 5,
      icon: Icons.eco_outlined,
      summary:
          'Omega-3, antioksidanlar ve yeterli hidrasyon beyin fonksiyonlarını destekleyebilir.',
      paragraphs: [
        'Beyin, vücudun en yoğun enerji tüketen organlarından biridir. Dengeli beslenme; odaklanma, hafıza ve genel bilişsel performans üzerinde olumlu etki yaratabilir.',
        'Omega-3 yağ asitleri (balık, ceviz, keten tohumu), antioksidan açısından zengin meyve-sebzeler (yaban mersini, ıspanak, brokoli) ve tam tahıllar beyin sağlığı için sıkça önerilir. İşlenmiş gıda, aşırı şeker ve doymuş yağ tüketiminin sınırlandırılması genel sağlık açısından faydalıdır.',
        'Günde yeterli su tüketimi, yorgunluk ve konsantrasyon kaybını azaltmaya yardımcı olabilir. Kafein tüketimini kişisel toleransa göre dengelemek de önemlidir.',
        'Sağlıklı beslenme tek başına tıbbi sorunların yerine geçmez. Kronik hastalığınız varsa veya ilaç kullanıyorsanız beslenme planınızı mutlaka hekiminizle birlikte oluşturun.',
      ],
    ),
    HealthArticle(
      id: 'mr-goruntuleme-nedir',
      title: 'MR görüntüleme nedir ve ne zaman gerekir?',
      category: 'Radyoloji',
      readMinutes: 4,
      icon: Icons.medical_information_outlined,
      summary:
          'Manyetik rezonans görüntüleme, yumuşak dokuları yüksek çözünürlükte gösteren radyasyonsuz bir yöntemdir.',
      paragraphs: [
        'Manyetik Rezonans (MR) görüntüleme, güçlü manyetik alan ve radyo dalgaları kullanarak beyin, omurilik ve diğer yumuşak dokuların detaylı görüntülerini oluşur. İşlem sırasında iyonize radyasyon kullanılmaz.',
        'Beyin MR’ı; inme, tümör, enfeksiyon, demyelinizan hastalıklar ve travma şüphesinde sıklıkla tercih edilir. Kontrast madde (gadolinium) bazı durumlarda lezyonların ayrımını kolaylaştırmak için uygulanabilir.',
        'MR çekimi genellikle 20–45 dakika sürer. Hasta hareketsiz kalmalıdır; klostrofobi veya metal implant varlığında hekiminize bilgi vermeniz gerekir.',
        'NeuralMedics, yalnızca mevcut MR görüntüleriniz üzerinde karar destek analizi sunar. Görüntüleme kararı ve yorumu mutlaka uzman radyolog tarafından yapılmalıdır.',
      ],
    ),
    HealthArticle(
      id: 'yapay-zeka-karar-destek',
      title: 'Yapay zeka destekli tıbbi karar destek sistemleri',
      category: 'Teknoloji',
      readMinutes: 7,
      icon: Icons.smart_toy_outlined,
      summary:
          'AI sistemleri hekimlere ve hastalara ek bilgi sunar; tanı ve tedavi kararını hekim verir.',
      paragraphs: [
        'Tıbbi karar destek sistemleri (CDSS), klinik verileri analiz ederek hekimlere risk değerlendirmesi, önceliklendirme ve ikinci görüş desteği sağlayabilir. Yapay zeka modelleri büyük veri setlerinden öğrenerek desen tanıma yeteneği kazanır.',
        'NeuralMedics, beyin MR görüntülerinde dört sınıf (glioma, meningioma, pituitary, tümör yok) için olasılık skorları üretir. Sonuçlar yerel cihazınızda saklanır; profil bilgileriniz ise güvenli bulut ortamında tutulur.',
        'AI modelleri %100 doğruluk garantisi vermez. Yanlış pozitif veya yanlış negatif sonuçlar mümkündür. Bu nedenle sistemimiz “karar destek” olarak konumlandırılmıştır; nihai klinik karar hekim tarafından verilmelidir.',
        'Sağlık profilinizdeki yaş, kilo, boy ve diğer bilgiler gelecekte analiz bağlamını zenginleştirmek için kullanılabilir. Verileriniz yalnızca size ait hesap altında saklanır.',
      ],
    ),
    HealthArticle(
      id: 'norolojik-muayene-oncesi',
      title: 'Nörolojik muayene öncesi bilmeniz gerekenler',
      category: 'Rehber',
      readMinutes: 4,
      icon: Icons.assignment_outlined,
      summary:
          'Muayeneye hazırlık, doğru değerlendirme ve zaman tasarrufu sağlayabilir.',
      paragraphs: [
        'Nörolog randevunuza gitmeden önce belirtilerinizi kronolojik olarak not edin: ne zaman başladı, nasıl ilerledi, tetikleyici faktörler var mı? Mümkünse eski MR/CD raporlarınızı yanınıza alın.',
        'Kullandığınız ilaçların listesini, alerjilerinizi ve geçirdiğiniz ameliyatları yazılı olarak getirmek muayeneyi hızlandırır. Ailede benzer nörolojik hastalık öyküsü varsa belirtin.',
        'NeuralMedics tarama geçmişinizden son analiz sonuçlarınızı hekiminizle paylaşabilirsiniz. Bu, görüşme sırasında ek bağlam sağlayabilir; ancak resmi raporların yerini almaz.',
        'Acil belirtiler (ani felç bulguları, şiddetli baş ağrısı, bilinç kaybı, nöbet) varsa randevu beklemeyin; 112’yi arayın veya en yakın acil servise başvurun.',
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
