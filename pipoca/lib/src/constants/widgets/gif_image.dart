import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';

class GifImagePreviewer extends StatefulWidget {
  final String image; 
  GifImagePreviewer({Key key, @required this.image}) : super(key: key);

  @override
  _GifImagePreviewerState createState() => _GifImagePreviewerState();
}

class _GifImagePreviewerState extends State<GifImagePreviewer>
    with TickerProviderStateMixin {
  GifController controller;

  @override
  void initState() {
    fetchGif( NetworkImage(widget.image));
    controller = GifController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return GifImage(
      controller: controller,
      image:  NetworkImage(widget.image) ,
    );
  }
}
