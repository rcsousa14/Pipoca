import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:share/share.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class CapturePngService {
  final SnackbarService _snackbarService = locator<SnackbarService>();
  Future<void> capturePng(key) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      final directory = (await getExternalStorageDirectory())!.path;
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/image.png');
      imgFile.writeAsBytes(pngBytes);
     
      Share.shareFiles(['$directory/image.png'], subject: 'Great picture', text: 'need to add something meanigfull here');
     
    } on PlatformException {
      _snackbarService.showSnackbar(
          message: "Tenta novamente erro desconhecido!");
    }
  }
}
