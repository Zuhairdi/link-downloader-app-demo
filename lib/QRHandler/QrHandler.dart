import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRHandler {
  static void _onQRViewCreated(
      QRViewController controller, Function(Barcode) receive) {
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();
      receive(scanData);
    });
  }

  static Widget qrScreen({
    required Function(Barcode) onReceiveData,
    required double height,
    required double width,
  }) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    return SizedBox(
      height: height,
      width: width,
      child: QRView(
        key: qrKey,
        onQRViewCreated: (ctrl) => _onQRViewCreated(ctrl, onReceiveData),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String url,
    required Function(String) startDownload,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        String mText = '';
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Url: $url', textAlign: TextAlign.left),
                TextFormField(
                  decoration: InputDecoration(labelText: 'File Name'),
                  onChanged: (value) => mText = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mText.isEmpty) return;
                startDownload(mText);
                Navigator.pop(context);
              },
              child: Text('Download'),
            ),
          ],
        );
      },
    );
  }
}
