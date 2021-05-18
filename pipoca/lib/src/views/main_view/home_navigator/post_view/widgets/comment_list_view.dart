import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/widgets/comment_list_view_model.dart';
import 'package:pipoca/src/views/main_view/widgets/shared/smart_widgets/bago_card_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:pipoca/src/views/main_view/widgets/shared/smart_widgets/bago_card_viewmodel.dart';

class CommentListView extends StatelessWidget {
  final FocusNode focus;
  final TextEditingController text;
  const CommentListView({
    Key? key,
    required this.focus, required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentListViewModel>.reactive(
        builder: (context, model, child) {
          if (!model.dataReady) {
            return loading();
          } else {
            if (model.data!.status == Status.ERROR) {
              return isError(model.data!.message!);
            }
            return model.data!.status == Status.COMPLETED && model.posts.isEmpty
                ? emptyList()
                : Stack(
                    children: [
                      FeedCaller(
                          caller: () => print('hi'),
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: model.posts.length,
                              itemBuilder: (context, index) {
                                List<Data> posts = model.posts;

                                return FeedCaller(
                                  itemCreated: () {
                                    if (model.data!.data != null) {
                                      SchedulerBinding.instance!
                                          .addPostFrameCallback(
                                              (duration) => print(index)
                                              // model.handleItemCreated(
                                              //     index, model.data!.data!)
                                              );
                                    }
                                  },
                                  child: BagoCard(
                                    focus: focus,
                                    text: text,
                                      type: Type.COMMENT,
                                      isError: false,
                                      chave: Key("${posts[index]}-comment"),
                                      bago: posts[index],
                                      isSingle: false),
                                );
                              }))
                    ],
                  );
          }
        },
        viewModelBuilder: () => CommentListViewModel());
  }
}

Widget loading() {
  return Container(
    width: double.infinity,
    height: 180,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget emptyList() {
  return Container(
    width: double.infinity,
    height: 180,
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Nenhum Commentario Novo',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget isError(String msg) {
  return Container(
    height: 180,
    width: double.infinity,
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
  );
}
