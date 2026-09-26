import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutriscan/app.dart';

void main() {
  testWidgets('app starts and shows the localized placeholder', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const ProviderScope(child: NutriScanApp()));
    await tester.pumpAndSettle();

    expect(find.text('NutriScan'), findsOneWidget);
    expect(find.text('Scanning starts here.'), findsOneWidget);
  });
}
