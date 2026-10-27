import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/plan_item.dart';
import '../services/plan_service.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<PlanService>();
    final total = service.plans.length;
    final completed = service.plans.where((p) => p.isCompleted).length;
    final rate = service.getCompletionRate();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistikalar',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Big progress circle
              Center(
                child: CircularPercentIndicator(
                  radius: 90,
                  lineWidth: 14,
                  percent: rate.clamp(0.0, 1.0),
                  animation: true,
                  animationDuration: 800,
                  center: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(rate * 100).toStringAsFixed(0)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6C5CE7),
                        ),
                      ),
                      Text(
                        'Tamamlanma',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  progressColor: const Color(0xFF6C5CE7),
                  backgroundColor: const Color(0xFF6C5CE7).withOpacity(0.15),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(height: 32),

              // Stats cards
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context,
                      'Ümumi plan',
                      '$total',
                      Icons.event_note,
                      const Color(0xFF6C5CE7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      context,
                      'Tamamlanan',
                      '$completed',
                      Icons.check_circle,
                      const Color(0xFF00B894),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context,
                      'Gözləyən',
                      '${total - completed}',
                      Icons.pending_actions,
                      const Color(0xFFE17055),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard(
                      context,
                      'Bu həftə',
                      '${service.getPlansForWeek(service.weekStart()).length}',
                      Icons.view_week,
                      const Color(0xFF00CEC9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Text(
                'İrəliləyiş',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _progressRow('Dərslər', service.typeRate(PlanType.lesson), const Color(0xFF6C5CE7)),
                    const SizedBox(height: 12),
                    _progressRow('Tapşırıqlar', service.typeRate(PlanType.task), const Color(0xFFFDCB6E)),
                    const SizedBox(height: 12),
                    _progressRow('Tədbirlər', service.typeRate(PlanType.event), const Color(0xFF00B894)),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressRow(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.poppins(fontSize: 14)),
            Text(
              '${(percent * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          lineHeight: 8,
          percent: percent,
          backgroundColor: color.withOpacity(0.15),
          progressColor: color,
          barRadius: const Radius.circular(4),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
