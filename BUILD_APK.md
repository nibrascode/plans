# Cədvəl — Android APK

Bu Flutter Android layihəsidir (veb deyil).

## Tələblər
- Flutter 3.16+
- Android Studio / Android SDK

## APK yığmaq

```bash
unzip Cedvel-Android.zip
cd Cedvel-Android

# Əgər android/ gradle tam deyilsə:
flutter create . --project-name cedvel --org com.nibrascode --platforms=android

flutter pub get
flutter run
flutter build apk --release
```

Nəticə: `build/app/outputs/flutter-apk/app-release.apk`

## Bu versiyada
- Demo plan yoxdur
- Cədvəl şəbəkəsi: günlər solda, saatlar yuxarıda
- Həftənin başlanğıcını seçmək
- Dərs xəbərdarlığı (bildiriş + səs)
- Planı redaktə etmək
- Real statistika
- Məxfilik siyasəti
- Giriş nümunə adı: Rəşad
- Cədvəli şəkil kimi qalereyaya yükləmək / paylaşmaq

Nibras Code © 2026
