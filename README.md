# shake

A Flutter package to detect phone shakes with directional information.

[![pub package](https://img.shields.io/pub/v/shake.svg)](https://pub.dev/packages/shake)

## Features

- Shake detection with directional information (X, Y, Z axes)
- Force measurement 
- Noise filtering option
- Configurable shake count and timing parameters

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  shake: ^3.0.0
```

## Usage

### Basic Usage

```dart
ShakeDetector detector = ShakeDetector.autoStart(
  onPhoneShake: (ShakeEvent event) {
    // Access detailed shake information
    print('Shake direction: ${event.direction}');
    print('Shake force: ${event.force}');
    print('Shake timestamp: ${event.timestamp}');
  }
);
```

OR

```dart
ShakeDetector detector = ShakeDetector.waitForStart(
  onPhoneShake: (ShakeEvent event) {
    // Handle the shake event
  }
);
    
detector.startListening();
```

### Breaking Changes in v3.0.0

Version 3.0.0 introduced a breaking change where `onPhoneShake` now receives a `ShakeEvent` parameter with information about direction, force, and timestamp.

If you're upgrading from v2.x, you need to update your callback to accept the ShakeEvent parameter:

```dart
// Before (v2.x)
ShakeDetector detector = ShakeDetector.autoStart(
  onPhoneShake: () {
    print('Shake detected!');
  }
);

// After (v3.x)
ShakeDetector detector = ShakeDetector.autoStart(
  onPhoneShake: (ShakeEvent event) {
    print('Shake detected!');
    // Now you can also access event.direction, event.force, etc.
  }
);
```

### Noise Filtering

```dart
ShakeDetector detector = ShakeDetector.autoStart(
  onPhoneShake: (ShakeEvent event) {
    // Handle shake
  },
  useFilter: true, // Enable noise filtering for more reliable detection
);
```

### Custom Configuration

```dart
ShakeDetector detector = ShakeDetector.autoStart(
  onPhoneShake: (ShakeEvent event) {
    // Handle shake
  },
  // Configure sensitivity - lower value makes it more sensitive
  shakeThresholdGravity: 2.0,
  // Minimum time between shake detections (ms)
  shakeSlopTimeMS: 300, 
  // Reset shake count after this time (ms)
  shakeCountResetTime: 2000,
  // Number of shakes required before triggering
  minimumShakeCount: 2,
);
```

### Directional Shake Information

The `ShakeEvent` provides the direction of the shake through the `direction` property:

```dart
ShakeDetector detector = ShakeDetector.autoStart(
  onPhoneShake: (ShakeEvent event) {
    switch (event.direction) {
      case ShakeDirection.x:
        print('Shaken horizontally (left/right)');
        break;
      case ShakeDirection.y:
        print('Shaken vertically (up/down)');
        break;
      case ShakeDirection.z:
        print('Shaken forward/backward');
        break;
      case ShakeDirection.undefined:
        print('Complex shake pattern');
        break;
    }
  }
);
```

### Stopping Detection

To stop listening:

```dart
detector.stopListening();
```

## Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| shakeThresholdGravity | Acceleration threshold for shake detection (in g) | 2.7 |
| shakeSlopTimeMS | Minimum time between shake detections (in ms) | 500 |
| shakeCountResetTime | Time before shake count resets (in ms) | 3000 |
| minimumShakeCount | Number of shakes required before shake is triggered | 1 |
| useFilter | Whether to apply noise filtering | false |

## License

This project is licensed under the MIT License - see your project's license file for details.


