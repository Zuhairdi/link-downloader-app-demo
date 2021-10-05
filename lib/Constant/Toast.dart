import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_download/Constant/Color.dart';

toast(String message) {
  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor(),
      textColor: Colors.white,
      fontSize: 16.0);
}
