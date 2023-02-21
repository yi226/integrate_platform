<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Cross-platform [Platform] and File Management.

## Features

- Use `IntegratePlatform` instead of `Platform` to get platform information in io and web.
- Packaged path_provider (In web, you'll get null).
- Packaged File Management. You can read and write a file in io and web.

## Getting started

To use this plugin, add `integrate_platform` as a dependency in your pubspec.yaml file.
```dart
dependencies:
  integrate_platform: ^1.0.0
```

## Usage
 
- Get platform information
```dart
// Get system version
bool operatingSystemVersion = IntegratePlatform.operatingSystemVersion;

// Get platform type
bool isDesktop = IntegratePlatform.isDesktop
```

- Get path in need
```dart

```

- Write and Read file
```dart

```

The whole examples are in `/example` folder.


## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
