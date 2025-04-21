import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

void main() => runApp(CoreControllerApp());

class CoreControllerApp extends StatefulWidget {
  @override
  State<CoreControllerApp> createState() => _CoreControllerAppState();
}

class _CoreControllerAppState extends State<CoreControllerApp> {
  List<int> cores = List.generate(12, (i) => i);
  Map<int, bool> coreStatus = {};
  bool autoRefresh = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchCoreStatus();
  }

  void fetchCoreStatus() async {
    for (var core in cores) {
      if (core == 0) {
        setState(() {
          coreStatus[core] = true; // CPU0 is always online
        });
        continue;
      }

      final file = File('/sys/devices/system/cpu/cpu$core/online');
      if (await file.exists()) {
        final value = await file.readAsString();
        setState(() {
          coreStatus[core] = value.trim() == '1';
        });
      }
    }
  }


  void toggleCore(int core, bool enable) async {
    final command = 'pkexec /home/hausemaster8281/StudioProjects/lool/lib/cpu-toggle.sh cpu$core ${enable ? '1' : '0'}';
    final result = await Process.run('bash', ['-c', command]);
    if (result.exitCode == 0) {
      fetchCoreStatus();
    } else {
      print("Failed: ${result.stderr}");
    }
  }

  void toggleAutoRefresh(bool enable) {
    setState(() {
      autoRefresh = enable;
    });

    _refreshTimer?.cancel();
    if (enable) {
      _refreshTimer = Timer.periodic(Duration(seconds: 5), (_) => fetchCoreStatus());
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPU Core Toggle',
      home: Scaffold(
        appBar: AppBar(
          title: Text('CPU Core Controller'),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: fetchCoreStatus,
            ),
            Switch(
              value: autoRefresh,
              onChanged: toggleAutoRefresh,
            )
          ],
        ),
        body: ListView(
          children: cores.map((core) {
            bool isOnline = coreStatus[core] ?? false;
            return ListTile(
              title: Text('CPU$core'),
              trailing: Switch(
                value: isOnline,
                onChanged: core == 0 ? null : (val) => toggleCore(core, val),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}