import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:industria/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PeatTrackerApp());

    // Verify that the app launches successfully
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
