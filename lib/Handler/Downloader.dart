import 'dart:io';

import 'package:dio/dio.dart';
import 'package:link_download/Handler/FileData.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  static start({
    required String filename,
    required String url,
    required Function(int) onProgress,
    required Function(FileData) onComplete,
    required VoidCallback onFailed,
  }) async {
    List<Directory>? tempDir =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    if (tempDir == null) return;
    String filePath = '${tempDir.first.path}/$filename';
    print(filePath);
    try {
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          int percentage = ((count / total) * 100).floor();
          onProgress(percentage);
        },
        deleteOnError: true,
      );
      FileData data = FileData(
          title: filename, filePath: filePath, progress: 100, url: url);
      onComplete(data);
    } catch (e) {
      print(e);
      onFailed();
    }
  }
}
