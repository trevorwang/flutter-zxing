import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fzxing/fzxing.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _barcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('barcode: $_barcode\n'),
              new RaisedButton(
                onPressed: () {
                  try {
                    Fzxing
                        .scan(isBeep: true, isContinuous: true)
                        .then((barcodeResult) {
                      print("flutter size:" + barcodeResult?.toString());
                      setState(() {
                        _barcode = barcodeResult;
                      });
                    });
                  } on PlatformException {
                    _barcode = 'Failed to get barcode.';
                  }
                },
                child: Text('scan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
