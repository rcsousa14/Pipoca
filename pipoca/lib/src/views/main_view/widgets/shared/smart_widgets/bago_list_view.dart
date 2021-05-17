import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/views/main_view/widgets/shared/smart_widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/widgets/shared/smart_widgets/bago_list_view_model.dart';
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
          if (!model.dataReady ||
              model.dataReady && model.data!.status == Status.LOADING) {
            return loading();
          } else {
            return model.data!.status == Status.COMPLETED && model.posts.isEmpty
                ? emptyList()
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
                                  model.data!.status != Status.STOP
                              ? model.refreshFeedFalse
                              : null,
                          child: RefreshIndicator(
                            onRefresh: () {
                              Completer<Null> completer = new Completer<Null>();

                              new Timer(new Duration(seconds: 3), () {
                                model.refreshFeedTrue;
                                completer.complete();
                              });
                              return completer.future;
                            },
                            child: ListView.separated(
                                key: model.pageStorage,
                                controller: controller,
                                physics: AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics()),
                                itemCount: model.posts.length + 2,
                                separatorBuilder: (context, index) {
                                  if (index == 0) {
                                    if (model.data!.status == Status.ERROR) {
                                      return isError(model.data!.message!);
                                    }
                                  }
                                  if (index == model.posts.length) {
                                    if (model.loading == true) {
                                      return isLoading();
                                    } else {
                                      if (model.dataReady && model.data!.status == Status.COMPLETED) {
                                        return isEnd(
                                            model.data!.data!.bagos!.nextPage ==
                                                null);
                                      }
                                      return Container();
                                    }
                                  }

                                  return Container();
                                },
                                itemBuilder: (context, index) {
                                  List<Data> posts = model.posts;
                                  if (index == 0 ||
                                      index == model.posts.length + 1) {
                                    return Container();
                                  }
                                  return FeedCaller(
                                    itemCreated: () {
                                      if (model.data!.data != null) {
                                        SchedulerBinding.instance!
                                            .addPostFrameCallback((duration) =>
                                                model.handleItemCreated(
                                                    index, model.data!.data!));
                                      }
                                    },
                                    child: BagoCard(
                                      isError: false,
                                      chave: Key(
                                          '${posts[index - 1].info!.id}-bago-key'),
                                      isSingle: false,
                                      goToPage: () => model.goToPost(
                                        bago: posts[index - 1],
                                      ),
                                      bago: posts[index - 1],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      BagoView(),
                    ],
                  );
          }
        },
        viewModelBuilder: () => BagoListViewModel());
  }
}

Widget loading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}

Widget emptyList() {
  return Center(
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Nenhum Bago Novo',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget isError(String msg) {
  return Center(
    child: Container(
      height: 85,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Erro durante a comunicação",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget isEnd(bool isEnd) {
  return isEnd == true
      ? Center(
          child: Container(
            height: 85,
            width: double.infinity,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                "ESTÁS ATUALIZADO",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        )
      : Container();
}

Widget isLoading() {
  return Center(
    child: Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: LoadingIndicator(
        indicatorType: Indicator.lineScale,
        color: Colors.grey.withOpacity(0.5),
      ),
    ),
  );
}
