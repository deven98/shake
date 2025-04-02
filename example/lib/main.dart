import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shake Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  ShakeDetector? _detector;
  String _lastShakeInfo = 'No shake detected yet';
  double _shakeThreshold = 2.7;
  bool _useFilter = false;
  int _minimumShakeCount = 1;
  
  @override
  void initState() {
    super.initState();
    _startDetector();
  }
  
  void _startDetector() {
    // Stop previous detector if exists
    _detector?.stopListening();
    
    _detector = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent event) {
        setState(() {
          _lastShakeInfo = 'Shake detected:\n'
              'Direction: ${event.direction}\n'
              'Force: ${event.force.toStringAsFixed(2)}\n'
              'Time: ${event.timestamp.toString()}';
        });
      },
      minimumShakeCount: _minimumShakeCount,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: _shakeThreshold,
      useFilter: _useFilter,
    );
  }

  @override
  void dispose() {
    _detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shake Detection Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Shake Info:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_lastShakeInfo),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Settings:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Sensitivity'),
              subtitle: Slider(
                value: _shakeThreshold,
                min: 1.0,
                max: 5.0,
                divisions: 20,
                label: _shakeThreshold.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _shakeThreshold = value;
                  });
                },
              ),
              trailing: Text('${_shakeThreshold.toStringAsFixed(1)} g'),
            ),
            SwitchListTile(
              title: const Text('Use Noise Filter'),
              subtitle: const Text('Smooths acceleration data'),
              value: _useFilter,
              onChanged: (value) {
                setState(() {
                  _useFilter = value;
                });
              },
            ),
            ListTile(
              title: const Text('Minimum Shake Count'),
              subtitle: Slider(
                value: _minimumShakeCount.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _minimumShakeCount.toString(),
                onChanged: (value) {
                  setState(() {
                    _minimumShakeCount = value.toInt();
                  });
                },
              ),
              trailing: Text('$_minimumShakeCount'),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _startDetector,
                child: const Text('Apply Settings'),
              ),
            ),
            const Spacer(),
            const Center(
              child: Text(
                'Shake your device to test!',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
