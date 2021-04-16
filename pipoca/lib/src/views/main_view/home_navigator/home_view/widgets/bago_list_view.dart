import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_list_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BagoListView extends StatelessWidget {
  const BagoListView({
    Key? key,
  }) : super(key: key);

  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BagoListViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) {
          return !model.dataReady
              ? Center(child: CircularProgressIndicator())
              : Builder(builder: (context) {
                  List<Data> posts = model.data!.data!.data!;
                  switch (model.data!.status) {
                    case Status.LOADING:
                      return Center(child: CircularProgressIndicator());
                    case Status.COMPLETED:
                      return VisibilityDetector(
                        key: UniqueKey(),
                        onVisibilityChanged: (VisibilityInfo visibilityInfo) {
                          var visiblePercentage =
                              visibilityInfo.visibleFraction * 100;
                          bool visible = visiblePercentage == 100;
                          model.changeVisibility(visible);
                        },
                        child: FeedCaller(
                          caller: () => model.isVisible == true
                              ? model.refreshFeed()
                              : null,
                          child: RefreshIndicator(
                            onRefresh: () {
                              Completer<Null> completer = new Completer<Null>();
                              model.refreshFeed();

                              new Timer(new Duration(seconds: 3), () {
                                completer.complete();
                              });

                              return completer.future;
                            },
                            child: ListView.separated(
                              key: PageStorageKey('hi'),
                              physics: BouncingScrollPhysics(),
                              itemCount: posts.length + 1,
                              separatorBuilder: (context, index) {
                                if (index == 0) {
                                  return Container(
                                    color: Colors.blue,
                                    width: double.infinity,
                                    height: 30,
                                  );
                                }
                                return Container();
                              },
                              itemBuilder: (context, index) {
                                if (index > 0) {
                                  // return BagoCard(
                                  //   filtered: model.isFilter,
                                  //   links: posts[index].post.links,
                                  //   page: model.currentIndex,
                                  //   bagoIndex: posts[index].post.id,
                                  //   text: posts[index].post.content,
                                  //   date: posts[index].post.createdAt,
                                  //   points: posts[index].post.votesTotal,
                                  //   creator: posts[index].post.creator.username,
                                  //   image: posts[index].post.creator.avatar,
                                  //   vote: posts[index].userVote,
                                  //   isVoted: posts[index].userVoted,
                                  //   commentsTotal:
                                  //       posts[index].post.commentsTotal,
                                  // );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                      );
                    case Status.ERROR:
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(model.data!.message),
                            ElevatedButton(
                              onPressed: () => model.refreshFeed(),
                              child: Text('Tentar Novamente'),
                            )
                          ],
                        ),
                      );

                    default:
                      return Container();
                  }
                });
        },
        viewModelBuilder: () => BagoListViewModel());
  }
}
