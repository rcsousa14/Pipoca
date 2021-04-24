import 'package:flutter/material.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view_model.dart';
import 'package:stacked/stacked.dart';

class PostView extends StatelessWidget {
 const PostView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<PostViewModel>.nonReactive(
     builder: (context, model, child) {
       return Scaffold();
},
     viewModelBuilder: () => PostViewModel(),
   );
 }
}