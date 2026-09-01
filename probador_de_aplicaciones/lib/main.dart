import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _display = '0';
  String _operation = '';
  double? _firstNumber;
  String? _operator;
  bool _startNewNumber = true;

  void _enterNumber(String number) {
    setState(() {
      if (_display == 'Error' || _startNewNumber) {
        _display = number;
        _startNewNumber = false;
      } else if (_display.length < 12) {
        _display += number;
      }
    });
  }

  void _enterDecimal() {
    setState(() {
      if (_display == 'Error' || _startNewNumber) {
        _display = '0.';
        _startNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _operation = '';
      _firstNumber = null;
      _operator = null;
      _startNewNumber = true;
    });
  }

  void _deleteLastDigit() {
    setState(() {
      if (_display == 'Error' || _startNewNumber || _display.length <= 1) {
        _display = '0';
        _startNewNumber = true;
      } else {
        _display = _display.substring(0, _display.length - 1);
        if (_display == '-') {
          _display = '0';
          _startNewNumber = true;
        }
      }
    });
  }



  void _toggleSign() {
    if (_display == 'Error' || _display == '0') return;

    setState(() {
      _display = _display.startsWith('-')
          ? _display.substring(1)
          : '-$_display';
    });
  }

  void _percentage() {
    if (_display == 'Error') return;

    setState(() {
      _display = _formatNumber(double.parse(_display) / 100);
      _startNewNumber = true;
    });
  }

  void _chooseOperator(String nextOperator) {
    if (_display == 'Error') {
      _clear();
      return;
    }

    setState(() {
      final currentNumber = double.parse(_display);

      if (_operator != null && !_startNewNumber && _firstNumber != null) {
        final result = _calculate(_firstNumber!, currentNumber, _operator!);
        if (result == null) {
          _showError();
          return;
        }
        _display = _formatNumber(result);
        _firstNumber = result;
      } else {
        _firstNumber = currentNumber;
      }

      _operator = nextOperator;
      _operation = '${_formatNumber(_firstNumber!)} $nextOperator';
      _startNewNumber = true;
    });
  }

  void _showResult() {
    if (_operator == null || _firstNumber == null || _display == 'Error') {
      return;
    }

    setState(() {
      final secondNumber = double.parse(_display);
      final selectedOperator = _operator!;
      final result = _calculate(_firstNumber!, secondNumber, selectedOperator);

      if (result == null) {
        _showError();
        return;
      }

      _operation =
          '${_formatNumber(_firstNumber!)} $selectedOperator ${_formatNumber(secondNumber)} =';
      _display = _formatNumber(result);
      _firstNumber = null;
      _operator = null;
      _startNewNumber = true;
    });
  }

  double? _calculate(double first, double second, String selectedOperator) {
    switch (selectedOperator) {
      case '+':
        return first + second;
      case '−':
        return first - second;
      case '×':
        return first * second;
      case '÷':
        return second == 0 ? null : first / second;
      default:
        return second;
    }
  }

  String _formatNumber(double value) {
    if (!value.isFinite) return 'Error';
    if (value == 0) return '0';

    final absoluteValue = value.abs();
    if (absoluteValue >= 1000000000000 || absoluteValue < 0.000000001) {
      return value.toStringAsExponential(6);
    }

    return value.toStringAsFixed(10).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _showError() {
    _display = 'Error';
    _operation = 'No se puede dividir entre cero';
    _firstNumber = null;
    _operator = null;
    _startNewNumber = true;
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF0B1020);
    const panel = Color(0xFF151B2E);
    const numberButton = Color(0xFF222A40);
    const functionButton = Color(0xFF313A52);
    const accent = Color(0xFF7C5CFC);

    ButtonStyle buttonStyle(Color color) {
      return ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
      );
    }

    Widget calculatorButton({
      required String text,
      required VoidCallback onPressed,
      Color color = numberButton,
      Color? textColor,
      Key? key,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox.expand(
            child: ElevatedButton(
              key: key,
              onPressed: onPressed,
              style: buttonStyle(color)
                  .copyWith(foregroundColor: WidgetStatePropertyAll(textColor)),
              child: Text(text),
            ),
          ),
        ),
      );
    }

    Widget buttonRow(List<Widget> buttons) {
      return Expanded(child: Row(children: buttons));
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calculate_rounded, color: accent, size: 28),
                        SizedBox(width: 10),
                        Text(
                          'Calculadora',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: panel,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFF293149)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _operation.isEmpty
                                  ? 'Lista para calcular'
                                  : _operation,
                              key: const Key('operation'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF9DA8C3),
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                _display,
                                key: const Key('display'),
                                style: TextStyle(
                                  color: _display == 'Error'
                                      ? const Color(0xFFFF6B7A)
                                      : Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w300,
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          buttonRow([
                            calculatorButton(
                              text: 'AC',
                              key: const Key('clear'),
                              onPressed: _clear,
                              color: functionButton,
                              textColor: const Color(0xFFB9A9FF),
                            ),
                            calculatorButton(
                              text: '⌫',
                              key: const Key('backspace'),
                              onPressed: _deleteLastDigit,
                              color: functionButton,
                              textColor: const Color(0xFFB9A9FF),
                            ),
                            calculatorButton(
                              text: '%',
                              key: const Key('percent'),
                              onPressed: _percentage,
                              color: functionButton,
                              textColor: const Color(0xFFB9A9FF),
                            ),
                            calculatorButton(
                              text: '÷',
                              key: const Key('divide'),
                              onPressed: () => _chooseOperator('÷'),
                              color: accent,
                            ),
                          ]),
                          buttonRow([
                            calculatorButton(
                              text: '7',
                              onPressed: () => _enterNumber('7'),
                            ),
                            calculatorButton(
                              text: '8',
                              onPressed: () => _enterNumber('8'),
                            ),
                            calculatorButton(
                              text: '9',
                              onPressed: () => _enterNumber('9'),
                            ),
                            calculatorButton(
                              text: '×',
                              key: const Key('multiply'),
                              onPressed: () => _chooseOperator('×'),
                              color: accent,
                            ),
                          ]),
                          buttonRow([
                            calculatorButton(
                              text: '4',
                              onPressed: () => _enterNumber('4'),
                            ),
                            calculatorButton(
                              text: '5',
                              onPressed: () => _enterNumber('5'),
                            ),
                            calculatorButton(
                              text: '6',
                              onPressed: () => _enterNumber('6'),
                            ),
                            calculatorButton(
                              text: '−',
                              key: const Key('subtract'),
                              onPressed: () => _chooseOperator('−'),
                              color: accent,
                            ),
                          ]),
                          buttonRow([
                            calculatorButton(
                              text: '1',
                              onPressed: () => _enterNumber('1'),
                            ),
                            calculatorButton(
                              text: '2',
                              onPressed: () => _enterNumber('2'),
                            ),
                            calculatorButton(
                              text: '3',
                              onPressed: () => _enterNumber('3'),
                            ),
                            calculatorButton(
                              text: '+',
                              key: const Key('add'),
                              onPressed: () => _chooseOperator('+'),
                              color: accent,
                            ),
                          ]),
                          buttonRow([
                            calculatorButton(
                              text: '±',
                              key: const Key('toggle-sign'),
                              onPressed: _toggleSign,
                            ),
                            calculatorButton(
                              text: '0',
                              onPressed: () => _enterNumber('0'),
                            ),
                            calculatorButton(
                              text: '.',
                              key: const Key('decimal'),
                              onPressed: _enterDecimal,
                            ),
                            calculatorButton(
                              text: '=',
                              key: const Key('equals'),
                              onPressed: _showResult,
                              color: const Color(0xFF28C6A0),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
