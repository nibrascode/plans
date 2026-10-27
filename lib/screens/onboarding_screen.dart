import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/plan_service.dart';
import 'main_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController(text: 'Rəşad');
  int _page = 0;

  final _pages = const [
    _OnboardData(
      icon: Icons.calendar_today_rounded,
      title: 'Gününü planla',
      subtitle: 'Dərs, tapşırıq və tədbirlərini bir yerdə saxla. Sadə və aydın.',
    ),
    _OnboardData(
      icon: Icons.insights_rounded,
      title: 'İrəliləyişini gör',
      subtitle: 'Statistika ilə nə qədər tamamladığını izlə. Motivasiya üçün kifayətdir.',
    ),
    _OnboardData(
      icon: Icons.workspace_premium_rounded,
      title: 'Premium ilə daha çox',
      subtitle: 'Limitsiz plan, ixrac, kateqoriyalar və təkmil alətlər. Əsasımız Premium-dur.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _finish() {
    final service = context.read<PlanService>();
    if (_nameController.text.trim().isNotEmpty) {
      service.setUserName(_nameController.text.trim());
    }
    service.completeOnboarding();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text('Keç', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length + 1,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  if (index < _pages.length) {
                    final p = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C5CE7).withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(p.icon, size: 48, color: const Color(0xFF6C5CE7)),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            p.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            p.subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  // Name page
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sənə necə müraciət edək?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adın ana səhifədə görünəcək',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        const SizedBox(height: 28),
                        TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Məsələn: Rəşad',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length + 1, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? const Color(0xFF6C5CE7)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_page < _pages.length) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _finish();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _page < _pages.length ? 'Davam et' : 'Başla',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardData {
  final IconData icon;
  final String title;
  final String subtitle;
  const _OnboardData({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
