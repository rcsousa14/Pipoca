import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/content_gif.dart';
import 'package:pipoca/src/constants/widgets/link_caller_model.dart';
import 'package:stacked/stacked.dart';

class LinkCaller extends StatelessWidget {
  final String url;
  final int index;
  
  const LinkCaller({Key key, @required this.url, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LinkViewModel>.reactive(
      builder: (context, model, child) {
        if (!model.dataReady) {
          return Container(
            constraints: BoxConstraints(
                minHeight: 190, minWidth: double.infinity, maxHeight: 210),
            decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: Platform.isIOS
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (model.data.data == null) {
            return Container(
                constraints: BoxConstraints(
                    minHeight: 190, minWidth: double.infinity, maxHeight: 210),
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Icon(Icons.link_off), Text('Ocorreu um erro!')],
                ));
          }
          return url.contains('gif')
              ? ContentVideo(url: model.data.data.videos[0].url)
              : url.contains('imgflip') || url.contains('imgur')
                  ? model.data.data.videos.length == 0
                      ? ContentImage(
                          isLink: false,
                          url: model.data.data.url,
                          image: CachedNetworkImageProvider(
                              model.data.data.images[0]))
                      : ContentVideo(url: model.data.data.videos[0].url)
                  : Builder(builder: (context) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (model.data.data.images.length != 0 ||
                                model.data.data.images == null) ...[
                              ContentImage(
                                isLink: true,
                                url: model.data.data.url,
                                image: CachedNetworkImageProvider(
                                    model.data.data.images[0],
                                    cacheKey: '$index- $url'),
                              )
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 6),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[200],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl:
                                            model.data.data.favicons[0] ?? "",
                                        imageBuilder: (context, imageProvider) {
                                          return Image(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                            width: 30,
                                            height: 30,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.link);
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.data.data.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              model.data.data.siteName,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
        }
      },
      viewModelBuilder: () => LinkViewModel(url),
    );
  }
}
