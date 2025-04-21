import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(CoreFrequencyControllerApp());

class CoreFrequencyControllerApp extends StatefulWidget {
  @override
  _CoreFrequencyControllerAppState createState() =>
      _CoreFrequencyControllerAppState();
}

class _CoreFrequencyControllerAppState
    extends State<CoreFrequencyControllerApp> {
  List<bool> _coresEnabled = [];
  List<double> _coreFrequencies = [];
  static const int minFrequency = 400; // Minimum frequency in MHz
  static const int maxFrequency = 4056; // Maximum frequency in MHz

  @override
  void initState() {
    super.initState();
    _initializeCores();
  }

  // Initialize the cores' statuses and frequencies
  Future<void> _initializeCores() async {
    // Assuming we know the number of cores (you can adjust based on your system)
    int numberOfCores = 4;  // Example: Assuming 4 cores. Adjust based on your CPU
    List<bool> coresEnabled = [];
    List<double> coreFrequencies = [];

    for (int i = 0; i < numberOfCores; i++) {
      // Check if core i is enabled (online)
      final result = await Process.run(
        'cat',
        ['/sys/devices/system/cpu/cpu$i/online'],
      );
      bool isCoreEnabled = result.stdout.trim() == '1';
      coresEnabled.add(isCoreEnabled);

      if (isCoreEnabled) {
        // Get the current frequency for the core
        final freqResult = await Process.run(
          'cat',
          ['/sys/devices/system/cpu/cpu$i/cpufreq/scaling_cur_freq'],
        );
        coreFrequencies.add(double.parse(freqResult.stdout.trim()) / 1000); // Convert to MHz
      } else {
        coreFrequencies.add(0.0);
      }
    }

    setState(() {
      _coresEnabled = coresEnabled;
      _coreFrequencies = coreFrequencies;
    });
  }

  // Set CPU frequency for a specific core
  Future<void> _setCpuFrequency(int core, double frequency) async {
    try {
      // Set the frequency using scaling_setspeed (in Hz)
      await Process.run(
        'sudo',
        [
          'sh',
          '-c',
          'echo ${(frequency * 1000).toInt()} > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_setspeed',
        ],
      );
      // Update frequency in the UI after setting it
      setState(() {
        _coreFrequencies[core] = frequency;
      });
    } catch (e) {
      print('Error setting frequency: $e');
    }
  }

  // Build the slider for each core
  Widget _buildFrequencySlider(int core) {
    return Column(
      children: [
        if (_coresEnabled[core]) ...[
          Text(
            'Core $core: ${_coreFrequencies[core].toStringAsFixed(2)} MHz',
            style: TextStyle(fontSize: 16),
          ),
          Slider(
            value: _coreFrequencies[core],
            min: minFrequency.toDouble(),
            max: maxFrequency.toDouble(),
            divisions: (maxFrequency - minFrequency) ~/ 100, // For a step size of 100 MHz
            label: '${_coreFrequencies[core].toStringAsFixed(2)} MHz',
            onChanged: (value) {
              _setCpuFrequency(core, value);
            },
          ),
        ] else ...[
          Text('Core $core is off', style: TextStyle(fontSize: 16)),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPU Frequency Controller',
      home: Scaffold(
        appBar: AppBar(
          title: Text('CPU Frequency Controller'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Text(
                'Adjust CPU Frequency for Each Core',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              for (int i = 0; i < _coresEnabled.length; i++)
                _buildFrequencySlider(i),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeCores,
                child: Text('Refresh Cores and Frequencies'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}