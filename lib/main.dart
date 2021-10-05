import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_download/Constant/Color.dart';
import 'package:link_download/MyHomePage.dart';
import 'package:link_download/Notification/NotificationHandler.dart';
import 'package:link_download/Provider/MainProvider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await NotificationHandler.init();
  var statuses = await [
    Permission.camera,
    Permission.storage,
    Permission.manageExternalStorage,
  ].request();
  if (statuses[Permission.camera] == PermissionStatus.denied)
    SystemNavigator.pop();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: primaryColor(),
        systemNavigationBarColor: primaryColor(),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Link Downloader',
      theme: ThemeData(
        primarySwatch: primaryColor(),
      ),
      home: ChangeNotifierProvider<MainProvider>(
          create: (context) => MainProvider(),
          builder: (context, child) => MyHomePage()),
    );
  }
}
