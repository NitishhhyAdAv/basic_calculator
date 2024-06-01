import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final ValueNotifier<String> _displayNotifier = ValueNotifier<String>('0');
  final ValueNotifier<String> _expressionNotifier = ValueNotifier<String>('');
  String _currentNumber = '0';
  String _operand = '';
  double _result = 0.0;
  bool _justPressedEquals = false;

  void _onNumberPressed(String value) {
    if (_justPressedEquals) {
      _currentNumber = value;
      _expressionNotifier.value = value;
      _justPressedEquals = false;
    } else {
      if (_currentNumber == '0' && value != '.') {
        _currentNumber = value;
      } else {
        _currentNumber += value;
      }
      _expressionNotifier.value += value;
    }
    _displayNotifier.value = _currentNumber;
  }

  void _onOperatorPressed(String value) {
    if (_operand.isNotEmpty) {
      _calculate();
    }
    _operand = value;
    _result = double.parse(_currentNumber);
    _currentNumber = '0';
    _expressionNotifier.value += ' $value ';
    _displayNotifier.value = _operand;
    _justPressedEquals = false;
  }

  void _onEqualsPressed() {
    if (_operand.isNotEmpty) {
      _calculate();
      _operand = '';
    }
    _displayNotifier.value = _result.toString();
    _currentNumber = _result.toString();
    _expressionNotifier.value = _currentNumber;
    _justPressedEquals = true;
  }

  void _calculate() {
    double currentValue = double.parse(_currentNumber);
    switch (_operand) {
      case '+':
        _result += currentValue;
        break;
      case '-':
        _result -= currentValue;
        break;
      case '×':
        _result *= currentValue;
        break;
      case '÷':
        _result /= currentValue;
        break;
    }
  }

  void _onClearPressed() {
    _result = 0.0;
    _currentNumber = '0';
    _operand = '';
    _displayNotifier.value = _currentNumber;
    _expressionNotifier.value = '';
    _justPressedEquals = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ValueListenableBuilder<String>(
            valueListenable: _expressionNotifier,
            builder: (context, value, child) {
              return Text(
                value,
                style: TextStyle(fontSize: 24, color: Colors.grey),
              );
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: _displayNotifier,
            builder: (context, value, child) {
              return Text(
                value,
                style: TextStyle(fontSize: 36),
              );
            },
          ),
          SizedBox(height: 20),
          CalculatorButtonRow(
            buttons: ['7', '8', '9', '÷'],
            onPressed: _onButtonPressed,
          ),
          CalculatorButtonRow(
            buttons: ['4', '5', '6', '×'],
            onPressed: _onButtonPressed,
          ),
          CalculatorButtonRow(
            buttons: ['1', '2', '3', '-'],
            onPressed: _onButtonPressed,
          ),
          CalculatorButtonRow(
            buttons: ['C', '0', '.', '+'],
            onPressed: _onButtonPressed,
          ),
          CalculatorButtonRow(
            buttons: ['='],
            onPressed: _onButtonPressed,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _onButtonPressed(String text) {
    if (text == 'C') {
      _onClearPressed();
    } else if (text == '=') {
      _onEqualsPressed();
    } else if (text == '+' || text == '-' || text == '×' || text == '÷') {
      _onOperatorPressed(text);
    } else {
      _onNumberPressed(text);
    }
  }
}

class CalculatorButtonRow extends StatelessWidget {
  final List<String> buttons;
  final Function(String) onPressed;

  const CalculatorButtonRow({super.key, 
    required this.buttons,
     required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((text) {
        return ElevatedButton(
          onPressed: () => onPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        );
      }).toList(),
    );
  }
}
