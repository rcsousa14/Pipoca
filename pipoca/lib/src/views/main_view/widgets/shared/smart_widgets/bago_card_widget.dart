import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/link_caller.dart';
import 'package:pipoca/src/constants/widgets/helpers/webview_screen.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/main_view/widgets/shared/smart_widgets/bago_card_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BagoCard extends StatelessWidget {
  final Data bago;
  final Function? goToPage;
  final bool isSingle;
  final Key chave;
  const BagoCard({
    required this.chave,
    required this.bago,
    required this.isSingle,
    this.goToPage,
  }) : super(key: chave);

  @override
  Widget build(BuildContext context) {
    GlobalKey key = GlobalKey();

    return ViewModelBuilder<BagoCardViewModel>.reactive(
      fireOnModelReadyOnce: true,
      onModelReady: (model) {
        model.getVote(bago.userVoted!, bago.userVote!, bago.info!.votesTotal);
        
      },
      builder: (context, model, child) {
        timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
        final time = DateTime.parse(bago.info!.createdAt);
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
          child: GestureDetector(
            onTap: () => goToPage != null ? goToPage!() : null,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.shade200, width: 1))),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // POST USER AVART
                          _Avatar(
                              key: Key('${bago.info!.id}-avatar'),
                              isError: model.dataReady &&
                                      model.data!.status == Status.ERROR
                                  ? true
                                  : false,
                              image: model.dataReady &&
                                      model.data!.status == Status.COMPLETED
                                  ? model.data!.data!.data!.info!.creator
                                      .avatar
                                  : bago.info!.creator.avatar),

                          // CONTENT WITH ERROR HANDLING
                          if (model.dataReady) ...[
                            _Content(
                              isError: model.data!.status == Status.ERROR,
                              globalKey: key,
                              text: bago.info!.content,
                              links: bago.info!.links,
                              index: bago.info!.id,
                              creator: model.data!.status != Status.ERROR &&
                                      model.data!.status == Status.COMPLETED
                                  ? model.data!.data!.data!.info!.creator
                                      .username
                                  : bago.info!.creator.username,
                              timeNow: timeNow,
                              points: model.data!.status != Status.ERROR &&
                                      model.data!.status == Status.COMPLETED
                                  ? model.data!.data!.data!.info!.votesTotal
                                  : bago.info!.votesTotal,
                              commentsTotal: model.data!.status !=
                                          Status.ERROR &&
                                      model.data!.status == Status.COMPLETED
                                  ? model
                                      .data!.data!.data!.info!.commentsTotal
                                  : bago.info!.commentsTotal,
                              isVoted: model.data!.status != Status.ERROR &&
                                      model.data!.status == Status.COMPLETED
                                  ? model.data!.data!.data!.userVoted!
                                  : bago.userVoted!,
                              vote: model.data!.status != Status.ERROR &&
                                      model.data!.status == Status.COMPLETED
                                  ? model.data!.data!.data!.userVote!
                                  : bago.userVote!,
                            ),
                          ],
                          if (!model.dataReady) ...[
                            _Content(
                              isError: false,
                              globalKey: key,
                              text: bago.info!.content,
                              links: bago.info!.links,
                              index: bago.info!.id,
                              creator: bago.info!.creator.username,
                              timeNow: timeNow,
                              points: bago.info!.votesTotal,
                              commentsTotal: bago.info!.commentsTotal,
                              isVoted: bago.userVoted!,
                              vote: bago.userVote!,
                            ),
                          ],
                          // // MORE BTN IT CHECKS IF CURRENT USER IS POST AUTHOR
                          _MoreBtn(
                            isError: model.dataReady &&
                                    model.data!.status == Status.ERROR
                                ? true
                                : false,
                            isSingle: isSingle,
                            index: bago.info!.id,
                            creator: model.dataReady &&
                                    model.data!.status != Status.ERROR
                                ? model.data!.data!.data!.info!.creator
                                    .username
                                : bago.info!.creator.username,
                          )
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
  final String? image;
  final bool? isError;
  final Key key;
  const _Avatar({required this.key, this.image, this.isError})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
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

    return Flexible(
        key: key,
        flex: 3,
        child: image == null
            ? Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/corn.png'),
                    fit: BoxFit.cover,
                  ),
                ))
            : isError == true
                ? Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.image_not_supported_rounded,
                        color: Colors.white))
                : Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: colors[index],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ));
  }
}

class _MoreBtn extends ViewModelWidget<BagoCardViewModel> {
  final bool isError;
  final int index;
  final String creator;
  final bool isSingle;
  const _MoreBtn({
    Key? key,
    required this.isError,
    required this.index,
    required this.creator,
    required this.isSingle,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: GestureDetector(
          onTap: () => creator == model.creator && isError == false
              ? model.delete(id: index, isSingle: isSingle)
              : null,
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
  final bool isError;
  final String creator, text;
  final String timeNow;
  final bool isVoted;
  final Links links;
  final GlobalKey globalKey;

  final int vote, points, commentsTotal, index;
  const _Content(
      {Key? key,
      required this.isError,
      required this.globalKey,
      required this.links,
      required this.text,
      required this.creator,
      required this.timeNow,
      required this.isVoted,
      required this.vote,
      required this.points,
      required this.index,
      required this.commentsTotal})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, BagoCardViewModel model) {
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
                padding:
                    EdgeInsets.only(top: 5, bottom: links.checkUrl() ? 30 : 10),
                child: ParsedText(
                  text: text.trim(),
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
                                      siteName: links.site != null
                                          ? links.site
                                          : links.url)));
                        }),
                    MatchText(
                        pattern: r"\B(\#[a-zA-Z]+\b)(?!;)",
                        style: TextStyle(color: Colors.blue[400], fontSize: 18),
                        onTap: (url) {
                          //TODO: launch url
                        })
                  ],
                )),
            links.checkUrl()
                ? Container()
                : LinkCaller(
                    isError: isError,
                    comments: commentsTotal,
                    links: links,
                    index: index,
                    vote: vote,
                    points: points,
                    isVoted: isVoted,
                    filter: model.filter,
                    page: model.page),

            // content link

            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
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
                              );
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
                                  color: model.points! >= 1
                                      ? red
                                      : model.points! <= -1
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
                              );
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
                              color: commentsTotal > 0
                                  ? Colors.grey.shade600
                                  : Colors.grey[400],
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Icon(
                            PipocaBasics.export,
                            size: 19,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('PARTILHAR',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
