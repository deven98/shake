# shake

A flutter package to detect phone shakes.

To listen to phone shake:

```dart
ShakeDetector detector = ShakeDetector.autoStart(
    onPhoneShake: () {
        // Do stuff on phone shake
    }
);
```

OR

```dart
ShakeDetector detector = ShakeDetector.waitForStart(
    onPhoneShake: () {
        // Do stuff on phone shake
    }
);

detector.startListening();
```

To stop listening:

```
detector.stopListening();
```
