import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/reminder_service.dart';

class ReminderBannerHost extends StatefulWidget {
  final Widget child;
  const ReminderBannerHost({super.key, required this.child});

  @override
  State<ReminderBannerHost> createState() => _ReminderBannerHostState();
}

class _ReminderBannerHostState extends State<ReminderBannerHost> {
  String? _autoHideId;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ReminderService>();
    final banner = service.banner;
    if (banner != null && _autoHideId != banner.id) {
      _autoHideId = banner.id;
      Future.delayed(const Duration(seconds: 10), () {
        if (!mounted) return;
        if (ReminderService.instance.banner?.id == banner.id) {
          ReminderService.instance.dismissBanner();
        }
      });
    }
    return Stack(
      children: [
        widget.child,
        if (banner != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            right: 12,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF6C5CE7),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 4, 12),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            banner.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            banner.body,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: service.dismissBanner,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
