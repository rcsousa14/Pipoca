import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/constants/widgets/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_list_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BagoListView extends StatelessWidget {
  final NavChoice choice;
  const BagoListView({Key key, this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BagoListViewModel>.reactive(
        disposeViewModel: false,
        builder: (context, model, child) {
   
          return !model.dataReady
              ? Center(child: CircularProgressIndicator())
              : model.dataReady && model.data.posts.data.isEmpty
                  ? Text('no data')
                  : VisibilityDetector(
                      key: Key('user-feed'),
                      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
                        var visiblePercentage =
                            visibilityInfo.visibleFraction * 100;
                        bool visible = visiblePercentage == 100;
                        model.changeVisibility(visible);
                      },
                      child: FeedCaller(
                        caller: () =>
                            model.isVisible ? model.refreshFeed() : null,
                        child: ListView.builder(
                          key: PageStorageKey('hi'),
                          physics: BouncingScrollPhysics(),
                          itemCount: model.data.posts.data.length,
                          itemBuilder: (context, index) {
                            Posts posts = model.data.posts;

                            return BagoCard(
                              links: posts.data[index].post.links,
                              page: model.currentIndex,
                              bagoIndex: posts.data[index].post.id,
                              text: posts.data[index].post.content,
                              date: posts.data[index].post.createdAt,
                              points: posts.data[index].post.votesTotal,
                              creator: posts.data[index].post.creator.username,
                              image: posts.data[index].post.creator.avatar,
                              vote: posts.data[index].userVote,
                              isVoted: posts.data[index].userVoted,
                              commentsTotal:
                                  posts.data[index].post.commentsTotal,
                            );
                          },
                        ),
                      ),
                    );
        },
        viewModelBuilder: () => BagoListViewModel());
  }
}
