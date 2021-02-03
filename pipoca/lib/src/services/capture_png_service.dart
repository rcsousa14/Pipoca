
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CapturePngService {
  Future<void> capturePng(key) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var png = byteData.buffer.asUint8List();

      Share.file('Bago', ui.ImageByteFormat.png.toString(), png, "images/png", text: "check out our app!");
    } catch (e) {
      print(e);
    }
  }
}