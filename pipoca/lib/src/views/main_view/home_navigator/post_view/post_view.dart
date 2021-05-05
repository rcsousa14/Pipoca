import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/bago_card_widget.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class PostView extends HookWidget {
  final Data bago;
  final bool isCreator, filter;
  final int page;
  const PostView(
      {Key? key,
      required this.bago,
      required this.isCreator,
      required this.page,
      required this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var focus = useFocusNode();
    var text = useTextEditingController();
    return ViewModelBuilder<PostViewModel>.reactive(
      builder: (context, model, child) {
      
        Widget loadingIndicator = focus.hasFocus == true
            ? GestureDetector(
                onTap: () {
                  focus.unfocus();
                  text.clear();
                },
                child: new Container(
                  color: Colors.black.withOpacity(0.6),
                  width: width,
                  height: height,
                ),
              )
            : Container();
        return Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _Header(
                tap: () => model.goBack(),
                isCreator: isCreator,
                report: () => print('report button'),
              )),
          body: Stack(
            children: [
              ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  !model.dataReady
                      ? BagoCard(
                          filtered: filter,
                          links: bago.info.links,
                          page: page,
                          bagoIndex: bago.info.id,
                          text: bago.info.content,
                          date: bago.info.createdAt,
                          points: bago.info.votesTotal,
                          creator: bago.info.creator.username,
                          image: bago.info.creator.avatar!,
                          vote: bago.userVote,
                          isVoted: bago.userVoted,
                          commentsTotal: bago.info.commentsTotal,
                        )
                      : FeedCaller(
                          caller: () => print('loading data'),
                          child: BagoCard(
                              text: model.data!.data!.data!.info.content,
                              filtered: filter,
                              date: model.data!.data!.data!.info.createdAt,
                              points: model.data!.data!.data!.info.votesTotal,
                              creator:
                                  model.data!.data!.data!.info.creator.username,
                              image:
                                  model.data!.data!.data!.info.creator.avatar!,
                              commentsTotal:
                                  model.data!.data!.data!.info.commentsTotal,
                              vote: model.data!.data!.data!.userVote,
                              page: page,
                              isVoted: model.data!.data!.data!.userVoted),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text(
                          'COMENTÁRIOS RECENTES',
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_drop_down_rounded,
                            color: Colors.grey.shade600)
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade50,
                    height: 1000,
                    width: double.infinity,
                  )
                ],
              ),
              Align(
                child: loadingIndicator,
                alignment: FractionalOffset.center,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _StringTextField(focus: focus, controller: text),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => PostViewModel(bago.info.id),
    );
  }
}

class _Header extends ViewModelWidget<PostViewModel> {
  final Function tap, report;

  final bool isCreator;
  const _Header({
    Key? key,
    required this.tap,
    required this.isCreator,
    required this.report,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, PostViewModel model) {
    return PostAppBar(
      back: () => tap(),
      isCreator: isCreator,
      report: () => report(),
    );
  }
}

class _StringTextField extends ViewModelWidget<PostViewModel> {
  final FocusNode focus;
  final TextEditingController controller;
  const _StringTextField(
      {Key? key, required this.focus, required this.controller})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, PostViewModel model) {
    return Material(
      elevation: 8,
      child: Container(
          // height: MediaQuery.of(context).size.height * 0.1,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: DetectableTextField(
            textInputAction: TextInputAction.send,
            onSubmitted: (value) {
              print(value);

              controller.clear();
            },
            focusNode: focus,
            textCapitalization: TextCapitalization.sentences,
            basicStyle: TextStyle(
              fontSize: 16,
            ),
            decoratedStyle: TextStyle(fontSize: 16, color: Colors.blue[400]),
            detectionRegExp: detectionRegExp(atSign: false)!,
            autofocus: false,
            cursorColor: Colors.blue[400],
            controller: controller,
            maxLength: 200,
            maxLines: null,
            // onChanged: (string) => print(string),
            decoration: InputDecoration(
              hintText: 'adicionar comentário...',
              hintStyle: TextStyle(fontSize: 16),
              border: InputBorder.none,
              counterText: "",
            ),
          )),
    );
  }
}
