import 'package:flutter/material.dart';
import 'package:link_download/Constant/Color.dart';
import 'package:link_download/Constant/Toast.dart';
import 'package:link_download/Handler/Downloader.dart';
import 'package:link_download/Handler/FileData.dart';
import 'package:link_download/Handler/SelectionDialog.dart';
import 'package:link_download/Notification/NotificationHandler.dart';
import 'package:link_download/Provider/MainProvider.dart';
import 'package:link_download/QRHandler/QrHandler.dart';
import 'package:link_download/main.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showCamera = false;

  refresh() {
    List<FileData> temp = [];
    (sharedPreferences.getStringList('DownloadedFile') ?? [])
        .forEach((element) {
      FileData? file = FileData.readRef(element);
      if (file != null) temp.add(file);
    });
    if (temp.isNotEmpty)
      Provider.of<MainProvider>(context, listen: false).filePath = temp;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (showCamera) {
          setState(() {
            showCamera = false;
          });
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: primaryColor(),
                ),
              ),
            ],
          ),
          body: Container(
            child: showCamera
                ? QRHandler.qrScreen(
                    onReceiveData: (value) {
                      setState(() {
                        showCamera = false;
                      });
                      QRHandler.show(
                        context: context,
                        url: value.code,
                        startDownload: (filename) {
                          //launch(value.code);
                          FileDownloader.start(
                            filename: filename,
                            url: value.code,
                            onProgress: (progress) {
                              NotificationHandler.progressNotification(
                                  progress);
                            },
                            onComplete: (fileData) {
                              NotificationHandler.localNotificationsPlugin
                                  .cancelAll();
                              FileData.saveToList(fileData);
                              refresh();
                            },
                            onFailed: () {
                              NotificationHandler.localNotificationsPlugin
                                  .cancelAll();
                              toast('Download failed');
                            },
                          );
                        },
                      );
                    },
                    height: size.height,
                    width: size.width,
                  )
                : Selector<MainProvider, List<FileData>>(
                    selector: (_, provider) => provider.filePath,
                    builder: (context, files, child) => ListView(
                      shrinkWrap: true,
                      children: files
                          .map((data) => Card(
                                child: ListTile(
                                  title: Text(data.title),
                                  subtitle: data.progress < 1
                                      ? LinearProgressIndicator(
                                          value: data.progress)
                                      : Text(data.filePath),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {},
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showSelectionDialog(
                context: context,
                onQRSelected: () => setState(() {
                  showCamera = !showCamera;
                }),
                onLinkSelected: () => showLinkDialog(
                  context: context,
                  startDownload: (handler) {
                    FileDownloader.start(
                      filename: handler.filename,
                      url: handler.url,
                      onProgress: (progress) {
                        NotificationHandler.progressNotification(progress);
                      },
                      onComplete: (fileData) {
                        NotificationHandler.localNotificationsPlugin
                            .cancelAll();
                        FileData.saveToList(fileData);
                        refresh();
                      },
                      onFailed: () {
                        NotificationHandler.localNotificationsPlugin
                            .cancelAll();
                        toast('Download failed');
                      },
                    );
                  },
                ),
              );
            },
            child: Icon(Icons.download),
          ),
        ),
      ),
    );
  }
}
