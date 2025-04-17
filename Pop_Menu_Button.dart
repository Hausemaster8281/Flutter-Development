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
  final TextEditingController resultController = TextEditingController();

  String? fromUnit;
  String? toUnit;
  double? result;

  final List<String> units = ['Kilometer', 'Meter', 'Centimeter', 'Millimeter'];

  /// Format: 'Unit': [factorToMeters, offset]
  final Map<String, List<double>> conversionFormulas = {
    'Kilometer': [1000.0, 0.0],
    'Meter': [1.0, 0.0],
    'Centimeter': [0.01, 0.0],
    'Millimeter': [0.001, 0.0],
  };

  void convert() {
    double? input = double.tryParse(valueController.text);
    if (input == null || fromUnit == null || toUnit == null) {
      setState(() {
        result = null;
        resultController.text = '';
      });
      return;
    }

    double fromFactor = conversionFormulas[fromUnit]![0];
    double toFactor = conversionFormulas[toUnit]![0];

    double inMeters = input * fromFactor;
    double converted = inMeters / toFactor;

    setState(() {
      result = converted;
      resultController.text = result!.toStringAsFixed(6).replaceAll(RegExp(r'\.?0*$'), '');
    });
  }

  Widget buildUnitDropdown({
    required String title,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      items: units.map((String unit) {
        return DropdownMenuItem<String>(
          value: unit,
          child: Text(unit),
        );
      }).toList(),
      onChanged: onChanged,
      isExpanded: true,
      hint: Text('Select $title'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Unit Converter'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Enter value',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: buildUnitDropdown(
                      title: 'From',
                      selectedValue: fromUnit,
                      onChanged: (value) {
                        setState(() {
                          fromUnit = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: buildUnitDropdown(
                      title: 'To',
                      selectedValue: toUnit,
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
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Convert', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: resultController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Result',
                  border: OutlineInputBorder(),
                ),
              ),
              if (result != null) ...[
                SizedBox(height: 20),
                Text(
                  '${valueController.text} $fromUnit = ${resultController.text} $toUnit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}