import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_calculator/main.dart';

Future<void> checkCalculation(
  WidgetTester tester,
  String first,
  String second,
  String operation,
  String expected,
) async {
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), first);
  await tester.enterText(fields.at(1), second);
  await tester.tap(find.widgetWithText(FilledButton, operation));
  await tester.pump();
  expect(find.text(expected), findsOneWidget);
}

void main() {
  testWidgets('Adding 2 + 2 equals 4', (tester) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(tester, '2', '2', '+', 'Result: 4');
  });

  testWidgets('Subtracting 8 - 2 equals 6', (tester) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(tester, '8', '2', '−', 'Result: 6');
  });

  testWidgets('Multiplication supports positive and negative numbers', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(tester, '8', '2', '×', 'Result: 16');
    await checkCalculation(tester, '-3', '2', '×', 'Result: -6');
  });

  testWidgets('Division returns whole and decimal results', (tester) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(tester, '8', '2', '÷', 'Result: 4');
    await checkCalculation(tester, '5', '2', '÷', 'Result: 2.5');
  });

  testWidgets('Adding 0.1 + 0.2 equals 0.3', (tester) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(tester, '0.1', '0.2', '+', 'Result: 0.3');
  });

  testWidgets('Division by zero shows an error', (tester) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(tester, '8', '0', '÷', 'Cannot divide by zero.');
  });

  testWidgets('Invalid input shows an error and allows correction', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await checkCalculation(
      tester,
      '',
      '2',
      '+',
      'Please enter two valid numbers.',
    );
    await checkCalculation(
      tester,
      'abc',
      '2',
      '+',
      'Please enter two valid numbers.',
    );
    await checkCalculation(tester, '5', '2', '+', 'Result: 7');
  });
}
