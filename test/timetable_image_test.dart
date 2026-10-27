import 'dart:ui' as ui;
import 'package:cedvel/widgets/timetable_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  testWidgets('timetable renders to PNG bytes', (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('az');
    final key = GlobalKey();
    await tester.pumpWidget(MaterialApp(
      home: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: key,
            child: TimetableImage(
                plans: const [], weekStart: DateTime(2026, 10, 26), userName: 'Rəşad'),
          ),
        ),
      ),
    ));
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final bytes = await tester.runAsync(() async {
      final img = await boundary.toImage(pixelRatio: 1);
      final d = await img.toByteData(format: ui.ImageByteFormat.png);
      return d!.lengthInBytes;
    });
    expect(bytes, greaterThan(1000));
  });
}
