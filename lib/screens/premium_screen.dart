import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium hələ satışda deyil — «Tezliklə». Bütün funksiyalar pulsuzdur.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D1B69), Color(0xFF1A1A2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
              const Spacer(),
              const Icon(Icons.workspace_premium, size: 72, color: Color(0xFFFFD700)),
              const SizedBox(height: 16),
              Text('Premium',
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Tezliklə',
                  style: GoogleFonts.poppins(
                      color: const Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Bu versiyada bütün funksiyalar tam pulsuzdur. Heç bir ödəniş tələb olunmur.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 15, height: 1.5),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
