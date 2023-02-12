// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:file_picker/file_picker.dart';

class IntegratePlatform {
  static String get operatingSystemVersion => "Web";
  static bool get isLinux => false;
  static bool get isMacOS => false;
  static bool get isWindows => false;
  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isDesktop => false;
  static bool get isMobile => false;
  static bool get isWeb => true;
  static String get pathSeparator => '/';

  static Future<String?> getCurrentDirectory() async {
    return null;
  }

  static Future<String?> getApplicationDocumentsDirectory() async {
    return null;
  }

  static Future<String?> getTemporaryDirectory() async {
    return null;
  }

  static _download({required String content, required String fileName}) {
    var blob = Blob([content], 'text/plain', 'native');

    AnchorElement(
      href: Url.createObjectUrlFromBlob(blob).toString(),
    )
      ..setAttribute("download", fileName)
      ..click();
  }

  static Future<FileResult> writeFile(String content, String name,
      {bool recursive = false, bool autoRename = false, String? path}) async {
    assert(name.split('.').length != 2);
    _download(content: content, fileName: name);
    return FileResult(success: true);
  }

  static Future<String?> pickSingleFile() async {
    return null;
  }

  static Future<FileResult> readFile(
    String? path, {
    ContentType contentType = ContentType.string,
    FileType fileType = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType, allowedExtensions: allowedExtensions, withData: true);

    if (result == null) {
      return FileResult(success: false, errorMessage: "No path.");
    }
    Uint8List fileBytes = result.files.first.bytes!;
    String fileName = result.files.first.name;
    switch (contentType) {
      case ContentType.string:
        return FileResult(
            success: true,
            content: String.fromCharCodes(fileBytes),
            path: fileName);
      case ContentType.byte:
        return FileResult(success: true, bytes: fileBytes, path: fileName);
    }
  }

  static Future<ui.Image?> getImage(String? path) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    if (result == null) {
      return null;
    }
    Uint8List fileBytes = result.files.first.bytes!;

    ui.Codec codec = await ui.instantiateImageCodec(fileBytes);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }
}

enum ContentType {
  string,
  byte,
}

class FileResult {
  FileResult({
    required this.success,
    this.path,
    this.content,
    this.bytes,
    this.errorMessage,
  });
  bool success;
  String? path;
  String? content;
  Uint8List? bytes;
  String? errorMessage;
  String get message => success ? 'success' : errorMessage ?? 'error';
}
