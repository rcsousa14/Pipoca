import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Content extends StatefulWidget {
  final ImageProvider<Object> image;
  final bool isLink;
  final String url;

  Content(
      {Key key, @required this.image, this.isLink, @required this.url})
      : super(key: key);

  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  void didChangeDependencies() {
    precacheImage(widget.image, context);
    super.didChangeDependencies();
  }

 

  @override
  Widget build(BuildContext context) {
   
    return Container(
      constraints: BoxConstraints(
          minHeight: 190, minWidth: double.infinity, maxHeight: widget.isLink
            ? 210:300),
      width: double.infinity,
      margin: widget.isLink == false ? EdgeInsets.only(bottom: 30) : null,
      
      child: ClipRRect(
      
        borderRadius: 
        widget.isLink
            ? BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))
            : 
            BorderRadius.all(Radius.circular(10)),
        child:  Image(
              frameBuilder: (context, child, frame, isFrame) {
                
                  return child;
                
                
              },
              image: widget.image,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator()
                          : CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, object, stackError) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(Icons.link_off), Text('Ocorreu um erro!')],
                  ),
                );
              },
            ),
      ),
    );
  }

 
}
