import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import '../models/plan_item.dart';

class ReminderEvent {
  final String id;
  final String title;
  final String body;
  ReminderEvent({required this.id, required this.title, required this.body});
}

class ReminderService extends ChangeNotifier {
  ReminderService._();
  static final instance = ReminderService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  ReminderEvent? banner;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Baku'));
    } catch (_) {}
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: (resp) {},
    );
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    _ready = true;
  }

  Future<void> requestPermission() async {
    await init();
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  int _nid(String planId) => planId.hashCode & 0x7fffffff;

  Future<void> schedule(PlanItem plan, {required bool enabled}) async {
    await init();
    await _plugin.cancel(_nid(plan.id));
    if (!enabled || plan.reminderOffsetMin == null) return;
    final when =
        plan.startTime.subtract(Duration(minutes: plan.reminderOffsetMin!));
    if (when.isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
      return;
    }
    final body = plan.reminderOffsetMin == 0
        ? 'indi başlayır'
        : '${plan.reminderOffsetMin} dəqiqə sonra başlayır';
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'cedvel_ders',
        'Dərs xəbərdarlığı',
        channelDescription: 'Dərs və plan xəbərdarlıqları',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
    );
    final tzWhen = tz.TZDateTime.from(when, tz.local);
    try {
      await _plugin.zonedSchedule(
        _nid(plan.id),
        plan.title,
        '$body${plan.location != null ? ' · ${plan.location}' : ''}',
        tzWhen,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (_) {
      try {
        await _plugin.zonedSchedule(
          _nid(plan.id),
          plan.title,
          '$body${plan.location != null ? ' · ${plan.location}' : ''}',
          tzWhen,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (e) {
        debugPrint('reminder schedule failed: $e');
      }
    }
  }

  Future<void> cancel(String planId) async {
    await init();
    await _plugin.cancel(_nid(planId));
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  Future<void> resync(List<PlanItem> plans, {required bool enabled}) async {
    await cancelAll();
    if (!enabled) return;
    for (final p in plans) {
      await schedule(p, enabled: true);
    }
  }

  void fireTest({required bool sound}) {
    showBanner(
      ReminderEvent(
        id: 'test-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Riyaziyyat dərsi',
        body: '10 dəqiqə sonra başlayır · Sinif 301',
      ),
      sound: sound,
    );
  }

  void showBanner(ReminderEvent event, {required bool sound}) {
    banner = event;
    notifyListeners();
    if (sound) {
      SystemSound.play(SystemSoundType.alert);
    }
  }

  void dismissBanner() {
    banner = null;
    notifyListeners();
  }
}
