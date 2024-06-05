import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('samples.flutter.dev/device');
  String _batteryLevel = 'Unknown battery level';
  String _signalStrength = 'Unknown signal strength';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level: $result %';
    } on PlatformException catch (e) {
      batteryLevel = 'Failed to get battery level: ${e.message}';
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> _getSignalStrength() async {
    String signalStrength;
    try {
      final dynamic result = await platform.invokeMethod('getSignalStrength');
      signalStrength = 'Signal strength: $result';
    } on PlatformException catch (e) {
      signalStrength = 'Failed to get signal strength: ${e.message}';
    }

    setState(() {
      _signalStrength = signalStrength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Device Info'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_batteryLevel),
              ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Get Battery Level'),
              ),
              const SizedBox(height: 20),
              Text(_signalStrength),
              ElevatedButton(
                onPressed: _getSignalStrength,
                child: const Text('Get Signal Strength'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
