import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/bago_card_widget.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view_model.dart';
import 'package:stacked/stacked.dart';

class PostView extends StatelessWidget {
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
    return ViewModelBuilder<PostViewModel>.nonReactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _Header(
                tap: () => model.goBack(),
                isCreator: isCreator,
                report: () => print('report button'),
              )),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              BagoCard(
                filtered: filter,
                links: bago.post.links,
                page: page,
                bagoIndex: bago.post.id,
                text: bago.post.content,
                date: bago.post.createdAt,
                points: bago.post.votesTotal,
                creator: bago.post.creator.username,
                image: bago.post.creator.avatar,
                vote: bago.userVote,
                isVoted: bago.userVoted,
                commentsTotal: bago.post.commentsTotal,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                   
                    Text('COMENTÁRIOS RECENTES', style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.bold),),
                    Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade600)
                  ],
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => PostViewModel(bago.post.id),
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
