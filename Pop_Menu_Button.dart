import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final TextEditingController valueController = TextEditingController();
  String? fromUnit;
  String? toUnit;
  double? result;

  final List<String> units = ['Kilometer', 'Meter', 'Centimeter', 'Millimeter'];

  // Conversion factors to meters
  final Map<String, double> toMeters = {
    'Kilometer': 1000.0,
    'Meter': 1.0,
    'Centimeter': 0.01,
    'Millimeter': 0.001
  };

  void convert() {
    double? input = double.tryParse(valueController.text);
    if (input == null || fromUnit == null || toUnit == null) {
      setState(() {
        result = null;
      });
      return;
    }

    double inMeters = input * toMeters[fromUnit]!;
    double converted = inMeters / toMeters[toUnit]!;

    setState(() {
      result = converted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Unit Converter')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: fromUnit,
                      hint: Text('From'),
                      items: units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          fromUnit = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: toUnit,
                      hint: Text('To'),
                      items: units.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          toUnit = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: convert,
                child: Text('Convert'),
              ),
              SizedBox(height: 20),
              Text(
                result != null
                    ? 'Result: ${result!.toStringAsFixed(10)} $toUnit'
                    : 'Enter a valid value and select units',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
