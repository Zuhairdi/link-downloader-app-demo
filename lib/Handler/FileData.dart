import 'package:link_download/main.dart';

class FileData {
  String title;
  String url;
  String filePath;
  double progress;

  FileData({
    required this.title,
    required this.url,
    required this.filePath,
    required this.progress,
  });

  @override
  String toString() => '$title, $url, $filePath, $progress';

  static FileData? readRef(String value) {
    if (value.isEmpty) return null;
    List<String> regex = value.split(',');
    return FileData(
      title: regex[0],
      url: regex[1],
      filePath: regex[2],
      progress: double.parse(regex[3]),
    );
  }

  static saveToList(FileData data) async {
    List<String> temp = sharedPreferences.getStringList('DownloadedFile') ?? [];
    temp.add(data.toString());
    await sharedPreferences.setStringList('DownloadedFile', temp);
  }
}
