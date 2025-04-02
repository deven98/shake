## [3.0.0] - 2024-04-20

### Breaking Changes:
* Changed `onPhoneShake` callback to receive a `ShakeEvent` parameter

### New Features:
* Added `ShakeDirection` enum for directional shake detection
* Added `ShakeEvent` class with direction, force, and timestamp
* Added noise filtering for smoother shake detection

### Updates:
* Updated sensors_plus dependency to v6.1.1
* Updated to modern Dart practices with improved typing
* Updated minimum SDK constraints to Dart 3.0.0
* Added linting and improved code quality
* Enhanced example app with configurable parameters

## [2.2.0]

* Updated sensors_plus dep
* Fixes flutter engine error

## [2.1.0]

* Added minimum shake count for triggering shake callback
* Updated sensors_plus dep

## [2.0.0]

* migrated from [`sensors`](https://pub.dev/packages/sensors) to [`sensors_plus`](https://pub.dev/packages/sensors_plus)

## [1.0.1] - 11/06/2021

* Changed callback return type
