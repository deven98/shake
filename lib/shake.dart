library shake;

import 'dart:async';
import 'dart:math';
import 'package:sensors/sensors.dart';

typedef Null PhoneShakeCallback();

class ShakeDetector {
  final PhoneShakeCallback onPhoneShake;
  final double shakeThresholdGravity;
  final int shakeSlopTimeMS;
  final int shakeCountResetTime;

  int mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int mShakeCount = 0;

  StreamSubscription streamSubscription;

  ShakeDetector.waitForStart(
      {this.onPhoneShake,
      this.shakeThresholdGravity = 2.7,
      this.shakeSlopTimeMS = 500,
      this.shakeCountResetTime = 3000});

  ShakeDetector.autoStart(
      {this.onPhoneShake,
      this.shakeThresholdGravity = 2.7,
      this.shakeSlopTimeMS = 500,
      this.shakeCountResetTime = 3000}) {
    startListening();
  }

  void startListening() {
    streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      double gX = x / 9.80665;
      double gY = y / 9.80665;
      double gZ = z / 9.80665;

      // gForce will be close to 1 when there is no movement.
      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        var now = DateTime.now().millisecondsSinceEpoch;
        // ignore shake events too close to each other (500ms)
        if (mShakeTimestamp + shakeSlopTimeMS > now) {
          return;
        }

        // reset the shake count after 3 seconds of no shakes
        if (mShakeTimestamp + shakeCountResetTime < now) {
          mShakeCount = 0;
        }

        mShakeTimestamp = now;
        mShakeCount++;

        onPhoneShake();
      }
    });
  }

  void stopListening() {
    streamSubscription.cancel();
  }
}
