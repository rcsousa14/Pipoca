import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/helpers/full_screen.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/helpers/webview_screen.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:cached_video_player/cached_video_player.dart';

class ContentImage extends StatefulWidget {
  final Links? links;
  final ImageProvider<Object> image;
  final int? index, points, page, vote, comments;
  final bool? isVoted, filter;
  final bool isLink, isError;

  ContentImage({
    Key? key,
    required this.image,
    this.isLink = false,
    required this.isError,
    this.index,
    this.points,
    this.page,
    this.isVoted,
    this.filter,
    this.vote,
    this.comments,
    this.links,
  }) : super(key: key);

  @override
  _ContentImageState createState() => _ContentImageState();
}

class _ContentImageState extends State<ContentImage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isError == false) {
      precacheImage(widget.image, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (widget.isError == false) {
          if (widget.isLink == false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FullScreen(
                        comments: widget.comments!,
                        vote: widget.vote!,
                        image: widget.image,
                        index: widget.index!,
                        page: widget.page!,
                        points: widget.points!,
                        isVoted: widget.isVoted!,
                        filter: widget.filter!,
                      )),
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                          url: widget.links!.url,
                          siteName: widget.links!.site!.isNotEmpty
                              ? widget.links!.site
                              : widget.links!.url,
                        )));
          }
        }
      },
      child: Container(
        constraints: BoxConstraints(
            minHeight: 190,
            minWidth: double.infinity,
            maxHeight: widget.isLink ? 210 : 280),
        width: double.infinity,
        // margin: widget.isLink == false ? EdgeInsets.only(bottom: 20) : null,
        child: ClipRRect(
            borderRadius: widget.isLink
                ? BorderRadius.only(
                    topLeft: Radius.circular(10), topRight: Radius.circular(10))
                : BorderRadius.all(Radius.circular(10)),
            child: imagePlace(widget.isError,
                image: widget.image,
                fullScreen: false,
                height: height,
                width: width,
                double: null)),
      ),
    );
  }
}

Widget imagePlace(bool isError,
    {required ImageProvider<Object> image,
    required bool fullScreen,
    required double height,
    required double,
    width}) {
  List colors = [
    Colors.blueGrey[800],
    Colors.brown[800],
    Colors.grey[900],
    Colors.teal[900],
    Colors.cyan[900],
    Colors.blue[900]
  ];
  Random random = new Random();
  int index = random.nextInt(colors.length);

  return isError == true
      ? Container(
          width: double.infinity,
          height: double.infinity,
          color: colors[index],
          child: Icon(Icons.image_not_supported_rounded),
        )
      : Image(
          frameBuilder: (context, child, frame, isFrame) {
            return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                ),
                child: child);
          },
          image: image,
          fit: fullScreen ? BoxFit.cover : BoxFit.cover,
          height: fullScreen ? height : null,
          width: fullScreen ? width : null,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
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
                                  loadingProgress.expectedTotalBytes!
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
        );
}

class ContentVideo extends StatefulWidget {
  final String url;
  final bool isError;
  ContentVideo({Key? key, required this.url, required this.isError})
      : super(key: key);

  @override
  _ContentVideoState createState() => _ContentVideoState();
}

class _ContentVideoState extends State<ContentVideo> {
  VideoPlayerController? controller;
  bool isPressed = false;
  late int index;
  List colors = [
    Colors.blueGrey[800],
    Colors.brown[800],
    Colors.grey[900],
    Colors.teal[900],
    Colors.cyan[900],
    Colors.blue[900]
  ];
  Random random = new Random();

  @override
  void initState() {
     index = random.nextInt(colors.length);
    if (widget.isError == false) {
      controller = VideoPlayerController.network(widget.url);
      controller!.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
        controller!.pause();
      });
    }

    super.initState();
  }
  //TODO: cache
  //https://pub.dev/packages/flutter_cache_manager
  //https://www.gitmemory.com/issue/flutter/flutter/28094/612075565
  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.only(bottom: 20),
      constraints: BoxConstraints(
          minHeight: 190,
          minWidth: double.infinity,
          maxHeight: controller!.value.isInitialized ? 300 : 200),
      child: controller!.value.isInitialized
          ? AspectRatio(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: GestureDetector(
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          isPressed = !isPressed;
                        });
                      }

                      if (isPressed == true) {
                        controller!.play();
                        controller!.setLooping(true);

                        Future.delayed(Duration(seconds: 65), () {
                          if (mounted) {
                            setState(() {
                              isPressed = false;
                            });
                          }

                          controller!.pause();
                          controller!.initialize();
                        });
                      } else {
                        controller!.pause();
                        controller!.initialize();
                      }
                    },
                    child: Stack(
                      children: [
                        VideoPlayer(controller!),
                        isPressed == false
                            ? Center(
                                child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: red, shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                    )))
                            : Container(),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                              padding: const EdgeInsets.all(4),
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Text(
                                'GIF',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                        )
                      ],
                    ),
                  )),
              aspectRatio: controller!.value.aspectRatio,
            )
          : widget.isError == false
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: Platform.isIOS
                          ? CupertinoActivityIndicator()
                          : CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: colors[index],
                  child: Icon(Icons.image_not_supported_rounded),
                ),
    );
  }
}
