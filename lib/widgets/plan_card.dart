import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/plan_item.dart';
import '../services/plan_service.dart';
import '../screens/plan_detail_screen.dart';

class PlanCard extends StatelessWidget {
  final PlanItem plan;
  final bool showDate;

  const PlanCard({super.key, required this.plan, this.showDate = false});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Dismissible(
      key: Key(plan.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<PlanService>().deletePlan(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan silindi')),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlanDetailScreen(planId: plan.id),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: plan.color.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: plan.color.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Time column
                Column(
                  children: [
                    Text(
                      timeFormat.format(plan.startTime),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 20,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: plan.color.withOpacity(0.4),
                    ),
                    Text(
                      timeFormat.format(plan.endTime),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Color bar
                Container(
                  width: 4,
                  height: 50,
                  decoration: BoxDecoration(
                    color: plan.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          decoration: plan.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if (plan.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          plan.subtitle!,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      if (plan.location != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(
                              plan.location!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Checkbox
                Checkbox(
                  value: plan.isCompleted,
                  activeColor: plan.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (_) {
                    context.read<PlanService>().toggleComplete(plan.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              plan.title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (plan.subtitle != null)
              Text(
                plan.subtitle!,
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            const SizedBox(height: 16),
            _infoRow(Icons.access_time, 
                '${DateFormat('HH:mm').format(plan.startTime)} – ${DateFormat('HH:mm').format(plan.endTime)}'),
            if (plan.location != null)
              _infoRow(Icons.location_on_outlined, plan.location!),
            if (plan.note != null && plan.note!.isNotEmpty)
              _infoRow(Icons.notes, plan.note!),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<PlanService>().deletePlan(plan.id);
                      Navigator.pop(ctx);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Sil'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PlanService>().toggleComplete(plan.id);
                      Navigator.pop(ctx);
                    },
                    child: Text(plan.isCompleted ? 'Geri al' : 'Tamamla'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 15))),
        ],
      ),
    );
  }
}
