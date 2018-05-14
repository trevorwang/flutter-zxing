import 'dart:async';

import 'package:flutter/services.dart';

class Fzxing {
  static const MethodChannel _channel = const MethodChannel('fzxing');

  static Future<List<String>> scan({
    bool isBeep = true,
    bool isContinuous = false,
    int continuousInterval = 1000,
  }) async {
    final List barcodes = await _channel.invokeMethod(
        'scan',
        Map()
          ..['isBeep'] = isBeep
          ..['isContinuous'] = isContinuous
          ..['continuousInterval'] = continuousInterval);
    return barcodes.map((it) => it as String).toList();
  }
}
