import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Simple Calculator',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
    home: const CalculatorPage(),
  );
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final firstNumber = TextEditingController();
  final secondNumber = TextEditingController();
  String result = 'Enter two numbers to begin.';

  @override
  void dispose() {
    firstNumber.dispose();
    secondNumber.dispose();
    super.dispose();
  }

  void calculate(String operation) {
    final a = double.tryParse(firstNumber.text.trim());
    final b = double.tryParse(secondNumber.text.trim());
    setState(() {
      if (a == null || b == null || !a.isFinite || !b.isFinite) {
        result = 'Please enter two valid numbers.';
        return;
      }
      if (operation == '÷' && b == 0) {
        result = 'Cannot divide by zero.';
        return;
      }
      final answer = switch (operation) {
        '+' => a + b,
        '−' => a - b,
        '×' => a * b,
        _ => a / b,
      };
      if (!answer.isFinite) {
        result = 'Result is too large.';
        return;
      }
      // Keep ordinary decimal results readable (for example, 0.1 + 0.2).
      final rounded = double.parse(answer.toStringAsPrecision(12));
      final text = rounded.toString();
      result =
          'Result: ${text.endsWith('.0') ? text.substring(0, text.length - 2) : text}';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Simple Calculator')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: firstNumber,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'First number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: secondNumber,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Second number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: ['+', '−', '×', '÷']
                      .map(
                        (operation) => FilledButton(
                          onPressed: () => calculate(operation),
                          child: Text(
                            operation,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    result,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
