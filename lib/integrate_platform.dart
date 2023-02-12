library integrate_platform;

export 'src/platform_io.dart' if (dart.library.html) 'src/platform_web.dart';
