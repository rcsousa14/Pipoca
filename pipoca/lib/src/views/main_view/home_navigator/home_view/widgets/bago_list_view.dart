import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/helpers/busy_btn_widget.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_list_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_loading_view.dart';
import 'package:stacked/stacked.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BagoListView extends StatelessWidget {
  final ScrollController controller;
  const BagoListView({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BagoListViewModel>.reactive(
        builder: (context, model, child) {
          if (!model.dataReady || model.data!.status == Status.LOADING) {
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80.0),
                          child: BusyBtn(
                            tap: () => model.refreshFeed(true, true),
                            text: 'Tentar Novamente',
                            txtColor: Colors.white, 
                            btnColor: red,
                           busy: model.isBusy,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : model.data!.status == Status.COMPLETED &&
                      model.data!.data!.bagos!.data.length == 0
                  ? Center(
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

                            model.changeVisibility(visible);
                          },
                          child: FeedCaller(
                            caller: () => model.isVisible == true &&
                                    model.data!.status == Status.COMPLETED
                                ? model.refreshFeed(false, false)
                                : null,
                            child: RefreshIndicator(
                              onRefresh: () => model.refreshFeed(false, true),
                              child: ListView.builder(
                                controller: controller,
                                  key: Key('list-key'),
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      model.data!.status == Status.COMPLETED
                                          ? model.posts.length
                                          : 0,
                                  itemBuilder: (context, index) {
                                    List<Data> posts = model.posts;

                                    return FeedCaller(
                                      itemCreated: () {
                                        SchedulerBinding.instance!
                                            .addPostFrameCallback((duration) =>
                                                model.handleItemCreated(
                                                    index, model.data!.data!));
                                      },
                                      child: BagoCard(
                                        goToPage: ()=> model.post( bago:posts[index], isCreator: posts[index].info.creator.username == model.creator, filter: model.filter, page: model.currentIndex),
                                        filtered: model.filter,
                                        links: posts[index].info.links,
                                        page: model.currentIndex,
                                        bagoIndex: posts[index].info.id,
                                        text: posts[index].info.content,
                                        date: posts[index].info.createdAt,
                                        points: posts[index].info.votesTotal,
                                        creator:
                                            posts[index].info.creator.username,
                                        image: posts[index].info.creator.avatar!,
                                        vote: posts[index].userVote,
                                        isVoted: posts[index].userVoted,
                                        commentsTotal:
                                            posts[index].info.commentsTotal,
                                     
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        BagoView(),
                      ],
                    );
        },
        viewModelBuilder: () => BagoListViewModel());
  }
}
