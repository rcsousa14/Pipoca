import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
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
    var height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<BagoCardViewModel>.reactive(
      onModelReady: (model) => model.linkCheck(),
      builder: (context, model, child) {
        timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
        final time = DateTime.parse(date);

        return RepaintBoundary(
          key: key,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(color: Colors.grey[200], width: 5))),
            padding: EdgeInsets.all(6),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(creator,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                    Text(
                                      ' • ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                        timeago
                                            .format(time, locale: 'pt_BR_short')
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  PipocaBasics.menu,
                                  size: 14,
                                  color: Colors.grey[800],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 6),
                          child: model.newText.isEmpty
                              ? Container()
                              : ParsedText(
                                  text: model.newText,
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 16),
                                  parse: <MatchText>[
                                    MatchText(
                                      type: ParsedType.URL,
                                      style: TextStyle(
                                          color: Colors.blue[400],
                                          fontSize: 14.5),
                                      onTap: (url) => model.social(url),
                                    ),
                                    MatchText(
                                        pattern: r"\B(\#[a-zA-Z]+\b)(?!;)",
                                        style: TextStyle(
                                            color: Colors.blue[400],
                                            fontSize: 16),
                                        onTap: (url) {
                                          //TODO: launch url
                                        })
                                  ],
                                )),
                      Container(
                        child: model.hasLink == true
                            ? model.url.contains('youtube') ||
                                    model.url.contains('youtu.be')
                                ? GestureDetector(
                                    onTap: () => model.social(model.url),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFFF0F1F2),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: model.youtube != null
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 8),
                                                Container(
                                                  height: height * .4,
                                                  child: Stack(
                                                    children: [
                                                      CachedNetworkImage(
                                                          imageUrl: model
                                                              .youtube
                                                              .thumbnailUrl,
                                                          fit: BoxFit.cover),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      .85),
                                                              shape: BoxShape
                                                                  .circle),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            color: Colors.white,
                                                            size: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .youtube,
                                                            color: Colors.red,
                                                          ),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              height: 45,
                                                              child: Text(
                                                                '${model.youtube.authorName} - ${model.youtube.title}',
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                    ),
                                  )
                                : FlutterLinkPreview(
                                    url: model.url,
                                    titleStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    builder: (info) {
                                      if (info == null) return const SizedBox();
                                      if (info is WebImageInfo) {
                                        return GestureDetector(
                                          //TODO: change it to double
                                          onTap: () {
                                            model.social(model.url);
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: info.image,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }

                                      final WebInfo webInfo = info;
                                      if (!WebAnalyzer.isNotEmpty(
                                          webInfo.title)) {
                                        return Container();
                                      }

                                      return GestureDetector(
                                        onDoubleTap: () =>
                                            model.social(model.url),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[50],
                                          ),
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              if (WebAnalyzer.isNotEmpty(
                                                  webInfo.image)) ...[
                                                const SizedBox(height: 8),
                                                CachedNetworkImage(
                                                  imageUrl: webInfo.image,
                                                  fit: BoxFit.cover,
                                                  // imageBuilder:
                                                  //     (context, imageProvider) {
                                                  //   return Container(
                                                  //     height: 100,
                                                  //     width: 300,

                                                  //     decoration: BoxDecoration(
                                                  //       image: DecorationImage(image: imageProvider,  fit: BoxFit.contain,)
                                                  //     ),
                                                  //   );
                                                  // },
                                                ),
                                              ],
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              webInfo.icon ??
                                                                  "",
                                                          imageBuilder: (context,
                                                              imageProvider) {
                                                            return Image(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit
                                                                  .contain,
                                                              width: 20,
                                                              height: 20,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return const Icon(
                                                                    Icons.link);
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Expanded(
                                                          child: Text(
                                                            webInfo.title,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (WebAnalyzer.isNotEmpty(
                                                        webInfo
                                                            .description)) ...[
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        webInfo.description,
                                                        maxLines: 5,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                            : Container(),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
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
                                  color:
                                      isVoted == true && vote == 1 ? red : Colors.grey[600],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Center(
                              child: Text('$points',
                                  style: TextStyle(
                                      color: points >= 1
                                          ? red
                                          : Colors.grey[600],
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
                                      : Colors.grey[600],
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
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Icon(
                              PipocaBasics.chat,
                              size: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => model.share(key),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              PipocaBasics.export,
                              size: 14.5,
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('PARTILHAR',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => BagoCardViewModel(text: text, page: page),
    );
  }
}
