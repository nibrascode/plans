import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/plan_service.dart';
import '../services/reminder_service.dart';
import '../services/timetable_export.dart';
import 'premium_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<PlanService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Parametrlər', style: GoogleFonts.poppins()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.isPremium ? 'Premium aktivdir' : 'Cədvəl Premium',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          service.isPremium
                              ? 'Bütün funksiyalar açıqdır'
                              : 'Limitsiz plan + əlavə xüsusiyyətlər',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Profil'),
          _tile(Icons.person_outline, 'Ad', trailing: service.userName, onTap: () {
            _editName(context, service);
          }),
          const SizedBox(height: 16),
          _sectionTitle('Ümumi'),
          _tile(Icons.dark_mode_outlined, 'Tema', trailing: _themeLabel(service.themeMode), onTap: () {
            _selectTheme(context, service);
          }),
          _tile(Icons.category_outlined, 'Kateqoriyalar', trailing: '${service.categories.length}', onTap: () {
            _manageCategories(context, service);
          }),
          _tile(Icons.language, 'Dil', trailing: 'Azərbaycan'),
          const SizedBox(height: 16),
          _sectionTitle('Cədvəl'),
          _tile(
            Icons.view_week_outlined,
            'Həftənin başlanğıcı',
            trailing: const {
              1: 'Bazar ertəsi',
              2: 'Çərşənbə axşamı',
              3: 'Çərşənbə',
              4: 'Cümə axşamı',
              5: 'Cümə',
              6: 'Şənbə',
              7: 'Bazar',
            }[service.weekStartsOn],
            onTap: () => _pickWeekStart(context, service),
          ),
          _tile(
            Icons.image_outlined,
            'Cədvəli şəkil kimi yüklə',
            trailing: 'PNG',
            onTap: () => TimetableExport.showSheet(
              context,
              plans: service.plans,
              weekStart: service.weekStart(),
              userName: service.userName,
            ),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Bildirişlər'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text('Dərs xəbərdarlığı', style: GoogleFonts.poppins()),
            value: service.remindersEnabled,
            onChanged: (v) => service.setRemindersEnabled(v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: Text('Səs', style: GoogleFonts.poppins()),
            value: service.soundEnabled,
            onChanged: (v) => service.setSoundEnabled(v),
          ),
          ListTile(
            leading: const Icon(Icons.notification_important_outlined),
            title: Text('Bildirişi sına', style: GoogleFonts.poppins()),
            onTap: () {
              ReminderService.instance.fireTest(sound: service.soundEnabled);
            },
          ),
          const SizedBox(height: 16),
          _sectionTitle('Məlumat'),
          _tile(Icons.code, 'JSON ixrac et', onTap: () => _export(context, service, isJson: true)),
          _tile(Icons.table_chart_outlined, 'CSV ixrac et', onTap: () => _export(context, service, isJson: false)),
          _tile(Icons.delete_outline, 'Bütün planları sil', onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Təsdiq'),
                content: const Text('Bütün planlar silinəcək. Əminsiniz?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Xeyr')),
                  TextButton(
                    onPressed: () {
                      service.clearAllPlans();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bütün planlar silindi')),
                      );
                    },
                    child: const Text('Bəli', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          _sectionTitle('Hüquqi'),
          _tile(Icons.privacy_tip_outlined, 'Məxfilik Siyasəti', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
            );
          }),
          const SizedBox(height: 16),
          _sectionTitle('Haqqında'),
          _tile(Icons.info_outline, 'Versiya', trailing: '1.2.0'),
          _tile(Icons.code, 'Nibras Code', trailing: 'Developer'),
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Cədvəl • Gününə nəzarət et\nNibras Code',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Açıq';
      case ThemeMode.dark:
        return 'Qaranlıq';
      default:
        return 'Sistem';
    }
  }

  void _editName(BuildContext context, PlanService service) {
    final controller = TextEditingController(text: service.userName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Adınız', style: GoogleFonts.poppins()),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Məsələn: Rəşad'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Ləğv')),
          TextButton(
            onPressed: () {
              service.setUserName(controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Saxla'),
          ),
        ],
      ),
    );
  }

  void _selectTheme(BuildContext context, PlanService service) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Sistem'),
              leading: const Icon(Icons.brightness_auto),
              onTap: () {
                service.setThemeMode(ThemeMode.system);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Açıq'),
              leading: const Icon(Icons.light_mode),
              onTap: () {
                service.setThemeMode(ThemeMode.light);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Qaranlıq'),
              leading: const Icon(Icons.dark_mode),
              onTap: () {
                service.setThemeMode(ThemeMode.dark);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _manageCategories(BuildContext context, PlanService service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final controller = TextEditingController();
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kateqoriyalar', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: service.categories.map((c) {
                      return Chip(
                        label: Text(c),
                        onDeleted: () {
                          service.removeCategory(c);
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Yeni kateqoriya',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          service.addCategory(controller.text);
                          controller.clear();
                          setModalState(() {});
                        },
                        icon: const Icon(Icons.add_circle, color: Color(0xFF6C5CE7)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _pickWeekStart(BuildContext context, PlanService service) {
    const labels = {
      1: 'Bazar ertəsi',
      2: 'Çərşənbə axşamı',
      3: 'Çərşənbə',
      4: 'Cümə axşamı',
      5: 'Cümə',
      6: 'Şənbə',
      7: 'Bazar',
    };
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: labels.entries
              .map(
                (e) => ListTile(
                  title: Text(e.value),
                  trailing: service.weekStartsOn == e.key
                      ? const Icon(Icons.check, color: Color(0xFF6C5CE7))
                      : null,
                  onTap: () {
                    service.setWeekStartsOn(e.key);
                    Navigator.pop(ctx);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _export(BuildContext context, PlanService service, {required bool isJson}) {
    if (!service.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İxrac Premium funksiyadır')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PremiumScreen()),
      );
      return;
    }
    final data = isJson ? service.exportToJson() : service.exportToCsv();
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isJson ? 'JSON panoya kopyalandı' : 'CSV panoya kopyalandı'),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.poppins()),
      trailing: trailing != null
          ? Text(trailing, style: GoogleFonts.poppins(color: Colors.grey))
          : const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
