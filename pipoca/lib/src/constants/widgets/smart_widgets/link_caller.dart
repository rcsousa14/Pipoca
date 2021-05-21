import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/helpers/content_gif.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/link_caller_model.dart';
import 'package:pipoca/src/constants/widgets/helpers/webview_screen.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:stacked/stacked.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LinkCaller extends StatelessWidget {
  final Links links;
  final int index, points, page, vote;
  final int? comments; 
  final bool isVoted, filter, isError;

  const LinkCaller(
      {Key? key,
      required this.links,
      required this.index,
      required this.points,
      required this.page,
      required this.isVoted,
      required this.filter,
      required this.isError,
      required this.vote,
      this.comments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String via = links.site != null ? links.site! : 'Postimg';
    return ViewModelBuilder<LinkViewModel>.reactive(
      builder: (context, model, child) {
        String key = 'bago-' + index.toString();
        return links.url!.contains('giphy') && links.video != null
            ? ContentVideo(url: links.video!, isError: isError)
            : links.url!.contains('imgflip') ||
                    links.url!.contains('postimg') ||
                    links.url!.contains('w3w') ||
                    links.url!.contains('giphy') ||
                    links.url!.contains('tenor')
                ? links.video == null || links.video!.isEmpty
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (links.image != null) ...[
                              ContentImage(
                                  isError: isError,
                                  comments: comments,
                                  vote: vote,
                                  index: index,
                                  page: page,
                                  points: points,
                                  isVoted: isVoted,
                                  filter: filter,
                                  isLink: false,
                                  image: CachedNetworkImageProvider(
                                      links.image!.isNotEmpty
                                          ? links.image!
                                          : links.url!,
                                      cacheKey: key)),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text: 'via',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13.5),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ' $via',
                                            style: TextStyle(
                                              color: Colors.blue[400],
                                              fontSize: 13.5,
                                              decoration: TextDecoration.none,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            WebViewScreen(
                                                              url: links.url,
                                                              siteName:
                                                                  links.site,
                                                            )));
                                              })
                                      ]),
                                ),
                              )
                            ],
                          ],
                        ),
                      )
                    : ContentVideo(url: links.video!, isError: isError)
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
                          if (links.image!.isNotEmpty) ...[
                            ContentImage(
                                isError: isError,
                                isLink: true,
                                links: links,
                                image: CachedNetworkImageProvider(
                                    links.image!.isNotEmpty
                                        ? links.image!
                                        : links.url!,
                                    cacheKey: key))
                          ],
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 6),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  links.title!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  links.site!,
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
