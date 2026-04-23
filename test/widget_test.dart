import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hu_library_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // بناء التطبيق وتشغيله
    await tester.pumpWidget(const MyApp());

    // التحقق من ظهور نص معين في شاشة البداية (مثلاً "Academic Library")
    expect(find.text('Academic Library'), findsOneWidget);
    
    // التحقق من ظهور أيقونة الكتاب
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
  });
}