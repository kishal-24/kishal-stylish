import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stylish/screens/login.dart';

void main() {
  testWidgets('login screen shows onboarding controls', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: login()));

    expect(find.text('skip'), findsOneWidget);
    expect(find.text('Prev'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
