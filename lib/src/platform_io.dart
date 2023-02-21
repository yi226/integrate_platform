import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart' as provider;

class IntegratePlatform {
  /// A string representing the version of the operating system or platform.
  ///
  /// The format of this string will vary by operating system, platform and
  /// version and is not suitable for parsing. For example:
  ///   "Linux 5.11.0-1018-gcp #20~20.04.2-Ubuntu SMP Fri Sep 3 01:01:37 UTC 2021"
  ///   "Version 14.5 (Build 18E182)"
  ///   '"Windows 10 Pro" 10.0 (Build 19043)'
  static String get operatingSystemVersion => Platform.operatingSystemVersion;

  /// Whether the operating system is a version of
  /// [Linux](https://en.wikipedia.org/wiki/Linux).
  ///
  /// This value is `false` if the operating system is a specialized
  /// version of Linux that identifies itself by a different name,
  /// for example Android (see [isAndroid]).
  static bool get isLinux => Platform.isLinux;

  /// Whether the operating system is a version of
  /// [macOS](https://en.wikipedia.org/wiki/MacOS).
  static bool get isMacOS => Platform.isMacOS;

  /// Whether the operating system is a version of
  /// [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows).
  static bool get isWindows => Platform.isWindows;

  /// Whether the operating system is a version of
  /// [Android](https://en.wikipedia.org/wiki/Android_%28operating_system%29).
  static bool get isAndroid => Platform.isAndroid;

  /// Whether the operating system is a version of
  /// [iOS](https://en.wikipedia.org/wiki/IOS).
  static bool get isIOS => Platform.isIOS;

  /// Whether the operating system is desktop.
  static bool get isDesktop =>
      Platform.isLinux || Platform.isWindows || Platform.isMacOS;

  /// Whether the operating system is mobile.
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Whether the operating system is web.
  static bool get isWeb => false;

  /// The path separator used by the operating system to separate components in file paths.
  static String get pathSeparator => Platform.pathSeparator;

  static Future<String> _getCurrentDirectory() async {
    String path;
    if (isDesktop) {
      path = Directory.current.path;
    } else {
      Directory appDocDir = await provider.getApplicationDocumentsDirectory();
      path = appDocDir.path;
    }
    return path;
  }

  /// Get the current directory path.
  ///
  /// Desktop: [Directory].current.path
  ///
  /// Mobile: Application documents directory
  ///
  /// Web: null
  static Future<String?> getCurrentDirectory() => _getCurrentDirectory();

  /// Get the application documents directory path.
  ///
  /// IO: https://github.com/flutter/plugins/tree/main/packages/path_provider/path_provider
  ///
  /// Web: null
  static Future<String?> getApplicationDocumentsDirectory() async {
    Directory appDocDir = await provider.getApplicationDocumentsDirectory();
    return appDocDir.path;
  }

  /// Get the temporary documents directory path.
  ///
  /// IO: https://github.com/flutter/plugins/tree/main/packages/path_provider/path_provider
  ///
  /// Web: null
  static Future<String?> getTemporaryDirectory() async {
    Directory appDocDir = await provider.getTemporaryDirectory();
    return appDocDir.path;
  }

  /// Write content to a file
  ///
  /// [name] needs to be suffixed, such as "hello.txt"
  ///
  /// If [recursive] is false, the default, the file is created only if all directories in its path already exist. If [recursive] is true, any non-existing parent paths are created first.
  ///
  /// If [autoRename] is false, the default, the file name will not change.If [autoRename] is true, the name will be added number to avoid duplication.
  ///
  /// If [path] is null, the default path is current path [getCurrentDirectory].
  ///
  /// The named parameters will not take effect in Web.Instead, users will get the file by automatic download.
  static Future<FileResult> writeFile(String content, String name,
      {bool recursive = false, bool autoRename = false, String? path}) async {
    assert(name.split('.').length == 2);
    int index = 0;
    String filePath = path ?? (await _getCurrentDirectory());
    String fileType = name.split('.').last;
    String fileName = name.split('.').first;
    String fileWholeName = '$filePath$pathSeparator$fileName.$fileType';
    File file = File(fileWholeName);
    if (autoRename) {
      while (file.existsSync()) {
        index++;
        fileWholeName = '$filePath$pathSeparator$fileName($index).$fileType';
        file = File(fileWholeName);
      }
    }
    try {
      await file.create(recursive: recursive);
      await file.writeAsString(content);
    } catch (e) {
      return FileResult(
          success: false, path: fileWholeName, errorMessage: e.toString());
    }
    return FileResult(success: true, path: fileWholeName);
  }

  /// Pick a single file.
  ///
  /// IO: https://github.com/miguelpruivo/flutter_file_picker
  ///
  /// Web: null
  static Future<String?> pickSingleFile({
    FileType fileType = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: fileType, allowedExtensions: allowedExtensions);

    if (result != null) {
      return result.files.single.path!;
    } else {
      return null;
    }
  }

  /// Read a File
  ///
  /// If [path] is null, the path will be picked by users using [pickSingleFile].
  ///
  /// The [path] will not take effect in Web.
  ///
  /// [contentType] determines the result type to be [String] or [Uint8List].
  ///
  /// Users will get [String] or [Uint8List] in io and [Uint8List] in web.
  static Future<FileResult> readFile({
    String? path,
    ContentType contentType = ContentType.string,
    FileType fileType = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    String? filePath = path ??
        (await pickSingleFile(
            fileType: fileType, allowedExtensions: allowedExtensions));
    if (filePath == null) {
      return FileResult(success: false, errorMessage: "No path.");
    }
    File file = File(filePath);
    if (!file.existsSync()) {
      return FileResult(success: false, errorMessage: "File is not exist.");
    }
    try {
      switch (contentType) {
        case ContentType.string:
          return FileResult(
              success: true,
              content: await file.readAsString(),
              path: filePath);
        case ContentType.byte:
          return FileResult(
              success: true, bytes: await file.readAsBytes(), path: filePath);
      }
    } catch (e) {
      return FileResult(success: false, errorMessage: e.toString());
    }
  }

  /// Get [ui.Image] in 'dart:ui' by the given path.
  ///
  /// If [path] is null, the path will be picked by users using [pickSingleFile].
  ///
  /// The [path] will not take effect in Web.
  static Future<ui.Image?> getImage(String? path) async {
    String? filePath = path ?? (await pickSingleFile(fileType: FileType.image));
    if (filePath == null) {
      return null;
    }
    final list = await File(filePath).readAsBytes();
    ui.Codec codec = await ui.instantiateImageCodec(list);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}

enum ContentType {
  string,
  byte,
}

class FileResult {
  /// The result of operation on file.
  FileResult({
    required this.success,
    this.path,
    this.content,
    this.bytes,
    this.errorMessage,
  });

  /// Indicates whether the file operation was successful.
  bool success;

  /// The full path to the final file.
  String? path;

  /// The Content of the file in [String].
  String? content;

  /// The Content of the file in [Uint8List].
  Uint8List? bytes;

  /// Information about the reason for the failure.
  String? errorMessage;

  /// Information about the operation.
  String get message => success ? 'success' : errorMessage ?? 'error';
}
