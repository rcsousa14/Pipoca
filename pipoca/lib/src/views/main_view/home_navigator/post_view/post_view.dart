import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class PostView extends StatelessWidget {
  final PageController controller;

  const PostView({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<PostViewModel>.reactive(
      onModelReady: (model)=> SystemChannels.textInput.invokeMethod('TextInput.show'),
      builder: (context, model, child) {

        return Column(
          children: <Widget>[
            _AppBarNewPost(
            
            ),
            new _StringTextField(),
          ],
        );
      },
      viewModelBuilder: () => PostViewModel( controller: controller,),
    );
  }
}

class _StringTextField extends HookViewModelWidget<PostViewModel> {
 
  const _StringTextField({Key key,}) : super(key: key, reactive: true);


  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    final focusNode = useFocusNode();
    var text = useTextEditingController();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 15, right: 16, top: 15),
              height: MediaQuery.of(context).size.height * .3489993,
              child: TextField(
                focusNode: focusNode,
                cursorColor: red,
                controller: text,
                maxLength: 200,
                maxLines: null,
               // autofocus: true,
                onChanged: model.updateString,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height * .08,
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    if (model.text.isNotEmpty) {
                      text.clear();
                      model.deleteString();
                    }
                  },
                  child: Container(
                      child: Text(
                    'Limpar',
                    style: TextStyle(
                        fontSize: 16,
                        color: model.text.length != 0 ? red : Colors.grey[400],
                        fontWeight: FontWeight.w500),
                  )),
                ),
                Container(
                  child: model.text.isEmpty
                      ? Container()
                      : Text(
                          '${model.text.length}' + '/200',
                          style: TextStyle(
                              color: model.text.length >= 200
                                  ? red
                                  : Colors.grey[400]),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarNewPost extends HookViewModelWidget<PostViewModel> {
  
  const _AppBarNewPost({Key key})
      : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => model.goBack(),
          child: Container(
            child: Icon(Icons.clear, size: 27),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              if (!model.isBusy) {
                model.addPost();
              }
            },
            child: Container(
              margin: EdgeInsets.all(15),
              width: 80,
              decoration: BoxDecoration(
                  color: red, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    PipocaBasics.quill,
                    size: 12,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text('Postar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
        title: Text('Novo Bago',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700)));
  }
}

class PostViewArguments {
  final Key key;
  final NavChoice choice;

  PostViewArguments({this.key, this.choice});
}
