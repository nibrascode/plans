import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Məxfilik Siyasəti', style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cədvəl – Məxfilik Siyasəti',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Son yenilənmə: 27 Oktyabr 2026 · Versiya 1.0.0',
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),

            _section(
              '1. Giriş',
              'Cədvəl (Nibras Code) sizin məxfiliyinizə hörmət edir. Tətbiq lokal işləyir və əsas istifadə üçün hesab (qeydiyyat) tələb olunmur. Ad, plan, cədvəl və bildiriş ayarlarınız bu cihazın yaddaşında qalır və serverə göndərilmir.',
            ),
            _section(
              '2. Hansı məlumatları saxlayırıq?',
              'Yalnız sizin daxil etdiyiniz məlumatlar: ad, dərs və planlar, kateqoriyalar, həftənin başlanğıcı, tema, xəbərdarlıq vaxtı.\n\nE-poçt, telefon, yer, kontakt və ödəniş məlumatı toplanmır.',
            ),
            _section(
              '3. Bildirişlər',
              'Dərs xəbərdarlığı üçün bildiriş icazəsi istəyə bilərik. Bildirişlər yalnız bu cihazda, seçdiyiniz vaxtda göstərilir. Səs eyni cihazda oxunur. Heç bir bildiriş mətni kənara ötürülmür.',
            ),
            _section(
              '4. Məlumatların istifadəsi',
              'Lokal məlumatlar yalnız cədvəli göstərmək, statistika hesablamaq və xəbərdarlıq vermək üçündür.',
            ),
            _section(
              '5. Üçüncü tərəflər',
              'Reklam, analitika və izləmə xidməti yoxdur. Məlumat paylaşılmır.',
            ),
            _section(
              '6. Pulsuz versiya və Premium',
              'Bu versiyada (1.0.0) bütün funksiyalar pulsuzdur. Ödənişli Premium hələ yoxdur («Tezliklə»); tətbiqdə heç bir ödəniş və ya ödəniş məlumatı toplanmır. Premium əlavə olunarsa, bu siyasət əvvəlcədən yenilənəcək.',
            ),
            _section(
              '7. Qalereyaya saxlama',
              'Cədvəli şəkil (PNG) kimi saxladığınız zaman tətbiq yalnız sizin istəyinizlə şəkli cihazınızın qalereyasına yazır. Bunun üçün qalereya/foto icazəsi istənə bilər. Tətbiq qalereyanızdakı digər şəkilləri oxumur və heç yerə göndərmir.',
            ),
            _section(
              '8. Məlumatların silinməsi',
              'Planları tətbiq daxilində silə, «Bütün planları sil» ilə hamısını təmizləyə və ya tətbiqi silməklə bütün lokal qeydləri silə bilərsiniz.',
            ),
            _section(
              '9. Uşaqlar',
              'Tətbiq ümumi istifadə üçündür. 13 yaşdan kiçik uşaqların şəxsi məlumatını toplamırıq.',
            ),
            _section(
              '10. Əlaqə',
              'Nibras Code\nE-poçt: nibrascode@gmail.com',
            ),

            const SizedBox(height: 30),
            Center(
              child: Text(
                'Nibras Code © 2026',
                style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
