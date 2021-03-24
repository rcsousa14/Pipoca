

import 'package:flutter/material.dart';

import 'package:pipoca/src/constants/widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/feed_caller.dart';

import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';

import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.nonReactive(
      onModelReady: (model) => model.pushFeed(),

      
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _Header(
                tap: ()=> Scaffold.of(context).openDrawer(),
              ),
            ),
            body: _Bago(),
            floatingActionButton: HomeFloatingAction(
              action: () =>   model.goToPost(model.choice),
            ));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class _Header extends ViewModelWidget<HomeViewModel> {
  final Function tap; 
  const _Header({Key key, this.tap}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    User user = model.user.user;
    return HomeAppBar(

      drawer: tap ,
      isFilter: model.isFilter,
      filter: () => model.showBasicBottomSheet(
          latest: 'Veja os Bagos mais recentes ⏲️',
          latestD: 'Fique a saber as últimas notícias em sua vizinhança.',
          trending: 'Veja o que esta a Pipocar 🍿',
          trendingD: 'Veja os Bagos que estão a Pipocar em sua vizinhança.'),
      image: user.avatar,
    );
  }
}

class _Bago extends ViewModelWidget<HomeViewModel> {
  const _Bago({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    return !model.dataReady
        ? Center(child: CircularProgressIndicator())
        : VisibilityDetector(
            key: Key('user-feed'),
            onVisibilityChanged: (VisibilityInfo visibilityInfo) {
              var visiblePercentage = visibilityInfo.visibleFraction * 100;
              bool visible = visiblePercentage == 100;
              model.changeVisibility(visible);
            },
            child: 
            FeedCaller(
              caller: () => model.isVisible ? model.refreshFeed() : null,
              child: 
              Builder(
                builder: (context) {
                  Posts posts = model.data.posts;
                  
                  return  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: posts.data.length,
                      itemBuilder: (context, index) {
                        return BagoCard(
                          page: model.currentIndex,
                          choice: model.choice,
                          bagoIndex: posts.data[index].post.id,
                          text: posts.data[index].post.content,
                          date: posts.data[index].post.createdAt,
                          points: posts.data[index].post.votesTotal,
                          creator: posts.data[index].post.creator.username,
                          image: posts.data[index].post.creator.avatar,
                          vote: posts.data[index].userVote,
                          isVoted: posts.data[index].userVoted,
                          commentsTotal: posts.data[index].post.commentsTotal,
                        );
                      });
                },
              ),
            ),
          );
  }
}
