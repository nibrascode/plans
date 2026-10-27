import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/plan_item.dart';
import '../services/plan_service.dart';
import 'add_plan_screen.dart';

class PlanDetailScreen extends StatelessWidget {
  final String planId;

  const PlanDetailScreen({super.key, required this.planId});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<PlanService>();
    PlanItem? plan;
    for (final p in service.plans) {
      if (p.id == planId) {
        plan = p;
        break;
      }
    }
    if (plan == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    final current = plan;
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('d MMMM yyyy, EEEE', 'az');

    return Scaffold(
      appBar: AppBar(
        title: Text('Dərs təfərrüatı', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPlanScreen(plan: current),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: plan.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: plan.color.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: plan.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        plan.type == PlanType.lesson
                            ? 'Dərs'
                            : plan.type == PlanType.task
                                ? 'Tapşırıq'
                                : plan.type == PlanType.event
                                    ? 'Tədbir'
                                    : 'Qeyd',
                        style: GoogleFonts.poppins(
                          color: plan.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    plan.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (plan.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      plan.subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            _infoTile(Icons.calendar_today, 'Tarix', dateFormat.format(plan.startTime)),
            _infoTile(
              Icons.access_time,
              'Vaxt',
              '${timeFormat.format(plan.startTime)} – ${timeFormat.format(plan.endTime)}',
            ),
            if (plan.location != null)
              _infoTile(Icons.location_on_outlined, 'Məkan', plan.location!),
            if (plan.note != null && plan.note!.isNotEmpty)
              _infoTile(Icons.notes, 'Qeyd', plan.note!),
            _infoTile(
              Icons.category_outlined,
              'Kateqoriya',
              plan.category,
            ),
            _infoTile(
              Icons.notifications_outlined,
              'Xəbərdarlıq',
              reminderLabel(plan.reminderOffsetMin),
            ),

            const SizedBox(height: 12),
            _infoTile(
              plan.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              'Status',
              plan.isCompleted ? 'Tamamlanıb' : 'Gözləyir',
            ),

            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final messenger = ScaffoldMessenger.of(context);
                      context.read<PlanService>().deletePlan(current.id);
                      Navigator.pop(context);
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Plan silindi')),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text('Sil', style: GoogleFonts.poppins(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<PlanService>().toggleComplete(current.id);
                      Navigator.pop(context);
                    },
                    icon: Icon(plan.isCompleted ? Icons.undo : Icons.check),
                    label: Text(
                      plan.isCompleted ? 'Geri al' : 'Tamamla',
                      style: GoogleFonts.poppins(),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.grey[600]),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
