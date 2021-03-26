import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';

import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/constants/widgets/content_gif.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/bago_card_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BagoCard extends StatelessWidget {
  final NavChoice choice;
  final bool isVoted;
  final int points, bagoIndex, commentsTotal, page, vote;
  final String creator, image, text, date;
  const BagoCard({
    Key key,
    this.bagoIndex,
    @required this.choice,
    @required this.text,
    @required this.date,
    @required this.points,
    @required this.creator,
    @required this.image,
    @required this.commentsTotal,
    @required this.vote,
    @required this.page,
    @required this.isVoted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey key = GlobalKey();

    return ViewModelBuilder<BagoCardViewModel>.nonReactive(
      onModelReady: (model) => model.linkCheck(text: text),
      fireOnModelReadyOnce: true,
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
        final time = DateTime.parse(date);
        String timeNow;
        String now = timeago
            .format(
              time,
              locale: 'pt_BR_short',
            )
            .toUpperCase();
        if (now.startsWith('~')) {
          timeNow = now.substring(1);
        } else {
          timeNow = now;
        }

        return RepaintBoundary(
          key: key,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[200], width: 1))),
            padding: EdgeInsets.all(6),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //image

                      _Avatar(image: image),

                      //need to separate these
                      _Content(
                        index: bagoIndex,
                        creator: creator,
                        timeNow: timeNow,
                        points: points,
                        commentsTotal: commentsTotal,
                        isVoted: isVoted,
                        vote: vote,
                      ),
                      //more button
                      _MoreBtn()
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => BagoCardViewModel(),
    );
  }
}

class _Avatar extends ViewModelWidget<BagoCardViewModel> {
  final String image;
  const _Avatar({Key key, @required this.image})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
    return Flexible(
      flex: 3,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.grey[350],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _MoreBtn extends ViewModelWidget<BagoCardViewModel> {
  const _MoreBtn({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: () => print('hi'),
        child: Icon(
          PipocaBasics.menu,
          size: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}

class _Content extends ViewModelWidget<BagoCardViewModel> {
  final String creator;
  final String timeNow;
  final bool isVoted;
  final int vote, points, commentsTotal, index;
  const _Content(
      {Key key,
      @required this.creator,
      @required this.timeNow,
      @required this.isVoted,
      @required this.vote,
      @required this.points,
      @required this.index,
      @required this.commentsTotal})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
    // String url =
    //    model.url.isNotEmpty || model.url !=null? model.url.substring(model.url.indexOf('//') + 2, model.url.length): '' ;
    // print(url);

    return Expanded(
      flex: 14,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(creator,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(
                  ' • ',
                  style: TextStyle(fontSize: 13.5),
                ),
                Text(timeNow,
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            //content
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    top: 5, bottom: model.hasLink == true ? 10 : 30),
                child: ParsedText(
                  text: model.newText,
                  style: TextStyle(color: Colors.grey[800], fontSize: 15.5),
                  parse: <MatchText>[
                    MatchText(
                        pattern: r"\B(\#[a-zA-Z]+\b)(?!;)",
                        style: TextStyle(color: Colors.blue[400], fontSize: 16),
                        onTap: (url) {
                          //TODO: launch url
                        })
                  ],
                )),

            model.hasLink == true
                ? model.url.contains('giphy')
                    ? Content(
                        isLink: false,
                        url: model.url,
                        image: CachedNetworkImageProvider(model.url,
                            cacheKey: '$index'),
                      )
                    : FlutterLinkPreview(
                        url: model.url,
                        useMultithread: true,
                        cache: Duration(seconds: 5),
                        titleStyle: TextStyle(fontWeight: FontWeight.bold),
                        builder: (info) {
                          if (info == null)
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                constraints: BoxConstraints(
                                    minHeight: 190,
                                    minWidth: double.infinity,
                                    maxHeight: 250),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 30),
                                child: Center(
                                  child: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: Platform.isIOS
                                        ? CupertinoActivityIndicator()
                                        : CircularProgressIndicator(),
                                  ),
                                ));
                          if (info is WebImageInfo) {
                            return Content(
                              isLink: false,
                              url: model.url,
                              image: CachedNetworkImageProvider(info.image,
                                  cacheKey: '$index'),
                            );
                          }

                          final WebInfo webInfo = info;
                          if (!WebAnalyzer.isNotEmpty(webInfo.title))
                            return const SizedBox();
                          return Container(
                            margin: EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                                  Content(
                                    isLink: true,
                                    url: model.url,
                                    image: CachedNetworkImageProvider(
                                        webInfo.image,
                                        cacheKey: '$index- ${model.url}'),
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
                                            imageUrl: webInfo.icon ?? "",
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Image(
                                                image: imageProvider,
                                                fit: BoxFit.contain,
                                                width: 30,
                                                height: 30,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
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
                                                  webInfo.title,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 13.5,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  model.newUrl,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                        })
                : Container(),
            //TODO: add stuff here

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () => model.upVote(),
                        child: Container(
                          child: Icon(
                            PipocaBasics.up_arrow,
                            size: 20,
                            color: isVoted == true && vote == 1
                                ? red
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                        child: Text('$points',
                            style: TextStyle(
                                color: points >= 1 ? red : Colors.grey[400],
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        highlightColor: Colors.red,
                        onTap: () => model.downVote(),
                        child: Container(
                          child: Icon(
                            PipocaBasics.down_arrow,
                            size: 20,
                            color: isVoted == true && vote == -1
                                ? Colors.black
                                : Colors.grey[400],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('$commentsTotal',
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: Icon(
                        PipocaBasics.chat,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => model.share(key),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        PipocaBasics.export,
                        size: 19,
                        color: Colors.grey[400],
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('PARTILHAR',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
