import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'services/plan_service.dart';
import 'services/reminder_service.dart';
import 'widgets/reminder_banner.dart';
import 'screens/main_shell.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('az', null);
  await ReminderService.instance.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CedvelApp());
}

class CedvelApp extends StatelessWidget {
  const CedvelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlanService()..load()),
        ChangeNotifierProvider<ReminderService>.value(
          value: ReminderService.instance,
        ),
      ],
      child: Consumer<PlanService>(
        builder: (context, service, _) {
          return MaterialApp(
            title: 'Cədvəl',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: service.themeMode,
            builder: (context, child) => ReminderBannerHost(
              child: child ?? const SizedBox.shrink(),
            ),
            home: !service.isLoaded
                ? const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
                    ),
                  )
                : service.onboardingDone
                    ? const MainShell()
                    : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
