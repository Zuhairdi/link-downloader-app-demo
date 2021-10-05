import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showSelectionDialog(
    {required BuildContext context,
    required Function() onQRSelected,
    required Function() onLinkSelected}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext selectionContext) {
      return AlertDialog(
        title: Text('Download from:'),
        contentPadding: EdgeInsets.all(10.0),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text('QR code'),
                trailing: Icon(Icons.qr_code),
                onTap: () {
                  Navigator.pop(selectionContext);
                  onQRSelected();
                },
              ),
              ListTile(
                title: Text('URL link'),
                trailing: Icon(Icons.edit),
                onTap: () {
                  Navigator.pop(selectionContext);
                  onLinkSelected();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showLinkDialog({
  required BuildContext context,
  required Function(String) startDownload,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      String nameText = '';
      String myText = '';
      TextEditingController _controller1 = TextEditingController();
      TextEditingController _controller2 = TextEditingController();
      return AlertDialog(
        contentPadding: EdgeInsets.all(10.0),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _controller2,
                decoration: InputDecoration(
                  labelText: 'File name',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      _controller2.clear();
                    },
                    icon: Icon(Icons.cancel_outlined),
                  ),
                ),
                onChanged: (value) => nameText = value,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _controller1,
                decoration: InputDecoration(
                  labelText: 'URL',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      ClipboardData? clipboard =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (clipboard == null) return;
                      _controller1.text = clipboard.text!;
                    },
                    icon: Icon(Icons.paste),
                  ),
                ),
                onChanged: (value) => myText = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (myText.isEmpty || nameText.isEmpty) return;
                if (!Uri.parse(myText).isAbsolute) return;
                startDownload(myText);
                Navigator.pop(context);
              },
              child: Text('Download'))
        ],
      );
    },
  );
}
