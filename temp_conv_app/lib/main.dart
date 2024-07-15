import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Temperature Converter',
    home: TemperatureConverter(),
  ));
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({Key? key}) : super(key: key);

  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _inputController = TextEditingController();
  double? _result;
  String _conversionType = 'F to C'; // Default conversion type
  List<String> _history = [];

  void _convertTemperature() {
    if (_inputController.text.isEmpty) {
      return;
    }
    double inputValue = double.tryParse(_inputController.text) ?? 0.0;
    double convertedValue;
    if (_conversionType == 'F to C') {
      convertedValue = (inputValue - 32) * 5 / 9;
    } else {
      convertedValue = inputValue * 9 / 5 + 32;
    }
    setState(() {
      _result = double.parse(convertedValue.toStringAsFixed(1)); // One decimal place
      String historyEntry = '$_conversionType: $inputValue => $_result';
      _history.insert(0, historyEntry); // Add to beginning of history list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Enter temperature',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _conversionType,
              onChanged: (String? newValue) {
                setState(() {
                  _conversionType = newValue!;
                });
              },
              items: <String>['F to C', 'C to F']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(
                'Result: $_result',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: _history
                        .map((entry) => ListTile(title: Text(entry)))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}