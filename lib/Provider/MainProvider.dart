import 'package:flutter/cupertino.dart';
import 'package:link_download/Handler/FileData.dart';

class MainProvider extends ChangeNotifier {
  List<FileData> _filePath = [];

  List<FileData> get filePath => _filePath;

  set filePath(List<FileData> value) {
    _filePath = value;
    notifyListeners();
  }

  addToFilePath(FileData fileData) {
    List<FileData> temp = filePath;
    temp.add(fileData);
    filePath = temp;
  }
}
