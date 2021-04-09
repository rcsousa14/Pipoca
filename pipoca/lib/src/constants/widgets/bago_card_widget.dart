import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:pipoca/src/constants/widgets/link_caller.dart';
import 'package:pipoca/src/constants/widgets/webview_screen.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/bago_card_viewmodel.dart';
import 'package:stacked/stacked.dart';

class BagoCard extends StatelessWidget {
  final bool isVoted, filtered;
  final Links links;
  final int points, bagoIndex, commentsTotal, page, vote;
  final String creator, image, text, date;

  const BagoCard({
    Key key,
    this.bagoIndex,
    @required this.text,
    this.links,
    @required this.filtered,
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

    return ViewModelBuilder<BagoCardViewModel>.reactive(
      onModelReady: (model) => model.getVote(isVoted, vote, points),
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
            child: GestureDetector(
              onTap: () => print('hi'),
              child: Container(
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
                            globalKey: key,
                            page: page,
                            filtered: filtered,
                            text: text,
                            links: links,
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
      child: image != null
          ? Container(
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
            )
          : Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                shape: BoxShape.circle,
              )),
    );
  }
}

class _MoreBtn extends ViewModelWidget<BagoCardViewModel> {
  const _MoreBtn({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: GestureDetector(
          onTap: () => print('hi'),
          child: Icon(
            PipocaBasics.menu,
            size: 14,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _Content extends ViewModelWidget<BagoCardViewModel> {
  final String creator, text;
  final String timeNow;
  final bool isVoted, filtered;
  final Links links;
  final GlobalKey globalKey;

  final int vote, points, commentsTotal, index, page;
  const _Content(
      {Key key,
      @required this.globalKey,
      @required this.links,
      @required this.text,
      @required this.filtered,
      @required this.page,
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
    // print(links.url == null);
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
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black)),
                Text(
                  ' • ',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Text(timeNow,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),

            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    top: 5, bottom: links.url != null ? 10 : 30),
                child: ParsedText(
                  text: text,
                  style: TextStyle(color: Colors.grey[800], fontSize: 18),
                  parse: <MatchText>[
                    MatchText(
                        type: ParsedType.URL,
                        style: TextStyle(color: Colors.blue[400], fontSize: 18),
                        onTap: (url) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                        url: url,
                                        siteName: links.url != null
                                            ? links.site
                                            : null,
                                      )));
                        }),
                    MatchText(
                        pattern: r"\B(\#[a-zA-Z]+\b)(?!;)",
                        style: TextStyle(color: Colors.blue[400], fontSize: 18),
                        onTap: (url) {
                          //TODO: launch url
                        })
                  ],
                )),

            links.url != null
                ? LinkCaller(
                    comments: commentsTotal,
                    links: links,
                    index: index,
                    vote: vote,
                    points: points,
                    isVoted: isVoted,
                    filter: filtered,
                    page: page)
                : Container(),

            // content link

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
                        onTap: () {
                          if (model.down == true && model.up == false ||
                              model.up == null) {
                            model.vote(
                                id: index,
                                vote: 1,
                                points: points,
                                isVoted: isVoted,
                                filter: filtered,
                                page: page);
                          }
                        },
                        child: Container(
                          child: Icon(
                            PipocaBasics.up_arrow,
                            size: 20,
                            color: model.up == true && model.down == false
                                ? red
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                        child: Text('${model.points}',
                            style: TextStyle(
                                color: model.points >= 1
                                    ? red
                                    : model.points <= -1
                                        ? Colors.black
                                        : Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        highlightColor: Colors.red,
                        onTap: () {
                          if (model.up == true && model.down == false ||
                              model.down == null) {
                            model.vote(
                                id: index,
                                vote: -1,
                                points: points,
                                isVoted: isVoted,
                                filter: filtered,
                                page: page);
                          }
                        },
                        child: Container(
                          child: Icon(
                            PipocaBasics.down_arrow,
                            size: 20,
                            color: model.down == true && model.up == false
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
                  onTap: () => model.share(globalKey),
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
