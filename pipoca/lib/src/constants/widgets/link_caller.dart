import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/content_gif.dart';
import 'package:pipoca/src/constants/widgets/full_screen.dart';
import 'package:pipoca/src/constants/widgets/link_caller_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:stacked/stacked.dart';

class LinkCaller extends StatelessWidget {
  final Links links;
  final int index;

  const LinkCaller({Key key, @required this.links, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String via = links.site ?? 'Postimg';
    return ViewModelBuilder<LinkViewModel>.reactive(
      builder: (context, model, child) {
        return links.url.contains('giphy')
            ? ContentVideo(url: links.video)
            : links.url.contains('imgflip') || links.url.contains('postimg')
                ? links.video == null || links.video.isEmpty
                    ? Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ContentImage(
                              isLink: false,
                              image: CachedNetworkImageProvider(links.image ?? links.url,
                                  cacheKey: '$index- ${links.site}')),
                           SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text('via $via', style: TextStyle(color: Colors.grey),),
                        )
                        ],
                      ),
                    )
                    : ContentVideo(url: links.video)
                : Builder(builder: (context) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (links.image.isNotEmpty ||
                              links.image != null) ...[
                            ContentImage(
                              isLink: true,
                              image: CachedNetworkImageProvider(links.image,
                                  cacheKey: '$index- ${links.site}'),
                            )
                          ],
                          Container(
                            width: double.infinity,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  links.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  links.site,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 13.5, color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
      },
      viewModelBuilder: () => LinkViewModel(),
    );
  }
}
