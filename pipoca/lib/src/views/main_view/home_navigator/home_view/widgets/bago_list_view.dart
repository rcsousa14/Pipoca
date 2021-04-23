import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_list_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/new_post_view.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BagoListView extends StatelessWidget {
  const BagoListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BagoListViewModel>.reactive(
        builder: (context, model, child) {
          if (!model.dataReady) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return model.dataReady && model.data!.status == Status.ERROR
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Erro durante a comunicação",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          model.data!.message!,
                          textAlign: TextAlign.center,
                        ),
                        ElevatedButton(
                          onPressed: () => model.refreshFeed(),
                          child: Text('Tentar Novamente'),
                        )
                      ],
                    ),
                  ),
                ): model.data!.status == Status.COMPLETED
                                && model.data!.data!.posts!.data.length == 0 ? 
                    Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       
                        Text(
                          'Nenhum Novo Bago',
                          textAlign: TextAlign.center,
                        ),
                        
                      ],
                    ),
                  ),
                )
              : Stack(
                  children: [
                    VisibilityDetector(
                      key: Key('my-widget-key'),
                      onVisibilityChanged: (visibilityInfo) {
                        bool visible =
                            visibilityInfo.visibleFraction * 100 != 0.0;
                        print(visible);
                        model.changeVisibility(visible);
                      },
                      child: FeedCaller(
                        caller: () => model.isVisible == true &&
                                model.data!.status == Status.COMPLETED
                            ? model.refreshFeed()
                            : null,
                        child: RefreshIndicator(
                          onRefresh: () => model.refreshFeed(),
                          child: ListView.separated(
                            key: Key('list-key'),
                            physics: BouncingScrollPhysics(),
                            itemCount: model.data!.status == Status.COMPLETED
                                ? model.data!.data!.posts!.data.length
                                : 0,
                            separatorBuilder: (context, index) {
                              if (index == 0) {
                                return NewPostView();
                              }
                              return Container();
                            },
                            itemBuilder: (context, index) {
                              List<Data> posts = model.data!.data!.posts!.data;
                              if (index > 0) {
                                return FeedCaller(
                                  itemCreated: () {
                                    print('Item created at $index');
                                  },
                                  child: BagoCard(
                                    filtered: model.filter,
                                    links: posts[index].post.links,
                                    page: model.currentIndex,
                                    bagoIndex: posts[index].post.id,
                                    text: posts[index].post.content,
                                    date: posts[index].post.createdAt,
                                    points: posts[index].post.votesTotal,
                                    creator: posts[index].post.creator.username,
                                    image: posts[index].post.creator.avatar,
                                    vote: posts[index].userVote,
                                    isVoted: posts[index].userVoted,
                                    commentsTotal:
                                        posts[index].post.commentsTotal,
                                    isNewPost: false,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                    ),
                    //TODO: check if is new data
                  ],
                );
        },
        viewModelBuilder: () => BagoListViewModel());
  }
}
