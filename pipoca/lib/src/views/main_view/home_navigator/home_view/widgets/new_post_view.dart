import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/smart_widgets/bago_card_widget.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/new_post_view_model.dart';
import 'package:stacked/stacked.dart';

class NewPostView extends StatelessWidget {
  const NewPostView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPostViewModel>.reactive(
      
        builder: (context, model, child) {
          return !model.post.checkContent() ?
          BagoCard(
         
            isNewPost: true,
            creator: model.user.username,
            image: model.user.avatar!,
            isVoted: false,
            page: 1,
            filtered: model.filter,
            vote: 0,
            points: 0,
            text: model.post.content!,
            commentsTotal: 0,
            date: DateTime.now().toString(),
          

          ) : 
          Container();
        },
        viewModelBuilder: () => NewPostViewModel());
  }
}
