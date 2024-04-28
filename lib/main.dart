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
  ValueNotifier<String> _displayNotifier = ValueNotifier<String>('0');
  String _currentNumber = '0';
  String _operand = '';
  double _result = 0.0;

  void _onNumberPressed(String value) {
    if (_currentNumber == '0' && value != '.') {
      _currentNumber = value;
    } else {
      _currentNumber += value;
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
    _displayNotifier.value = _operand;
  }

  void _onEqualsPressed() {
    if (_operand.isNotEmpty) {
      _calculate();
      _operand = '';
    }
    _displayNotifier.value = _result.toString();
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
          ValueListenableBuilder(
            valueListenable: _displayNotifier,
            builder: (context, value, child) {
              return Text(
                value,
                style: TextStyle(fontSize: 36),
              );
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('÷'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('×'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('C'),
              _buildButton('0'),
              _buildButton('.'),
              _buildButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildButton('='),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'C') {
          _onClearPressed();
        } else if (text == '=') {
          _onEqualsPressed();
        } else if (text == '+' || text == '-' || text == '×' || text == '÷') {
          _onOperatorPressed(text);
        } else {
          _onNumberPressed(text);
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
