import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_calculator/main.dart';

void main() {
  testWidgets('Adding 2 + 2 equals 4', (tester) async {
    await tester.pumpWidget(const MyApp());

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '2');
    await tester.enterText(fields.at(1), '2');
    await tester.tap(find.widgetWithText(FilledButton, '+'));
    await tester.pump();

    expect(find.text('Result: 4'), findsOneWidget);
  });

  testWidgets('Calculates all four operations and handles invalid input', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final fields = find.byType(TextField);
    Future<void> check(
      String a,
      String b,
      String operation,
      String expected,
    ) async {
      await tester.enterText(fields.at(0), a);
      await tester.enterText(fields.at(1), b);
      await tester.tap(find.widgetWithText(FilledButton, operation));
      await tester.pump();
      expect(find.text(expected), findsOneWidget);
    }

    await check('8', '2', '+', 'Result: 10');
    await check('8', '2', '−', 'Result: 6');
    await check('8', '2', '×', 'Result: 16');
    await check('8', '2', '÷', 'Result: 4');
    await check('-3', '2', '×', 'Result: -6');
    await check('0.1', '0.2', '+', 'Result: 0.3');
    await check('8', '0', '÷', 'Cannot divide by zero.');
    await check('', '2', '+', 'Please enter two valid numbers.');
    await check('abc', '2', '+', 'Please enter two valid numbers.');
    await check('5', '2', '÷', 'Result: 2.5');
  });
}
