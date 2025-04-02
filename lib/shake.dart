library shake;

import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Direction of the shake detected
enum ShakeDirection {
  /// Shake detected in x direction (left/right)
  x,
  
  /// Shake detected in y direction (up/down)
  y,
  
  /// Shake detected in z direction (forward/backward)
  z,
  
  /// Mixed/general shake direction
  undefined
}

/// Event data for a shake event
class ShakeEvent {
  /// Direction of the shake
  final ShakeDirection direction;
  
  /// Force of the shake
  final double force;
  
  /// Time when the shake occurred
  final DateTime timestamp;

  /// Creates a new shake event
  ShakeEvent({
    required this.direction,
    required this.force,
    required this.timestamp,
  });
}

/// Callback for phone shakes with detailed event information
typedef PhoneShakeCallback = void Function(ShakeEvent event);

/// ShakeDetector class for phone shake functionality
class ShakeDetector {
  /// User callback for phone shake
  final PhoneShakeCallback onPhoneShake;

  /// Shake detection threshold
  final double shakeThresholdGravity;

  /// Minimum time between shake
  final int shakeSlopTimeMS;

  /// Time before shake count resets
  final int shakeCountResetTime;

  /// Number of shakes required before shake is triggered
  final int minimumShakeCount;
  
  /// Whether to use a filtered approach to reduce noise
  final bool useFilter;

  int _shakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int _shakeCount = 0;
  
  // Filter variables
  final List<double> _filterBuffer = <double>[];
  static const int _filterSamples = 5;

  /// StreamSubscription for Accelerometer events
  StreamSubscription<AccelerometerEvent>? streamSubscription;

  /// This constructor waits until [startListening] is called
  ShakeDetector.waitForStart({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
    this.minimumShakeCount = 1,
    this.useFilter = false,
  });

  /// This constructor automatically calls [startListening] and starts detection and callbacks.
  ShakeDetector.autoStart({
    required this.onPhoneShake,
    this.shakeThresholdGravity = 2.7,
    this.shakeSlopTimeMS = 500,
    this.shakeCountResetTime = 3000,
    this.minimumShakeCount = 1,
    this.useFilter = false,
  }) {
    startListening();
  }

  /// Starts listening to accelerometer events
  void startListening() {
    streamSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        final double x = event.x;
        final double y = event.y;
        final double z = event.z;

        final double gX = x / 9.80665;
        final double gY = y / 9.80665;
        final double gZ = z / 9.80665;

        // gForce will be close to 1 when there is no movement.
        double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);
        
        if (useFilter) {
          // Apply a simple moving average filter
          if (_filterBuffer.length >= _filterSamples) {
            _filterBuffer.removeAt(0);
          }
          _filterBuffer.add(gForce);
          
          // Calculate the average
          gForce = _filterBuffer.reduce((a, b) => a + b) / _filterBuffer.length;
        }

        if (gForce > shakeThresholdGravity) {
          final int now = DateTime.now().millisecondsSinceEpoch;
          
          // ignore shake events too close to each other (500ms)
          if (_shakeTimestamp + shakeSlopTimeMS > now) {
            return;
          }

          // reset the shake count after 3 seconds of no shakes
          if (_shakeTimestamp + shakeCountResetTime < now) {
            _shakeCount = 0;
          }

          _shakeTimestamp = now;
          _shakeCount++;

          if (_shakeCount >= minimumShakeCount) {
            // Determine the primary direction of the shake
            ShakeDirection direction;
            final double absX = gX.abs();
            final double absY = gY.abs();
            final double absZ = gZ.abs();
            
            if (absX > absY && absX > absZ) {
              direction = ShakeDirection.x;
            } else if (absY > absX && absY > absZ) {
              direction = ShakeDirection.y;
            } else if (absZ > absX && absZ > absY) {
              direction = ShakeDirection.z;
            } else {
              direction = ShakeDirection.undefined;
            }
            
            // Create a shake event
            final ShakeEvent shakeEvent = ShakeEvent(
              direction: direction,
              force: gForce,
              timestamp: DateTime.fromMillisecondsSinceEpoch(now),
            );
            
            // Call the main callback with shake event information
            onPhoneShake(shakeEvent);
          }
        }
      },
    );
  }

  /// Stops listening to accelerometer events
  void stopListening() {
    streamSubscription?.cancel();
    _filterBuffer.clear();
  }
}
