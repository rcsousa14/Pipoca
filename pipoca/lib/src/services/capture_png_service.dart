import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class CapturePngService {
  final SnackbarService _snackbarService = locator<SnackbarService>();
  Future<void> capturePng(key) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);

      ByteData byteData =
          (await image.toByteData(format: ui.ImageByteFormat.png))!;
      var png = byteData.buffer.asUint8List();

      // Share.file('Bago', ui.ImageByteFormat.png.toString(), png, "images/png",
      //     text: "check out our app!");
      //Share.text('hello', 'check this app', 'helo');
    } catch (e) {
      print(e);
      // _snackbarService.showSnackbar(
      //     message: "Tenta novamente erro desconhecido!");
    }
  }
}
