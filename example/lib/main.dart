import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late final ShakeDetector detector;
  var shakes = 0;

  @override
  void initState() {
    super.initState();

    // ShakeDetector.waitForStart() waits for user to call detector.startListening();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () => setState(() => shakes++),
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  void dispose() {
    // To close:
    detector.stopListening();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: Text(
            shakes == 0 ? "Shake it!" : "Shaked $shakes time(s)",
          ),
        ),
      ),
    );
  }
}
