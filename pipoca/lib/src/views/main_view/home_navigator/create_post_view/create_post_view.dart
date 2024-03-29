import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/create_post_view/create_post_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CreatePostView extends HookWidget {
  const CreatePostView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var focus = useFocusNode();
    var text = useTextEditingController();
    return ViewModelBuilder<CreatePostViewModel>.reactive(
      builder: (context, model, child) {
        return VisibilityDetector(
          key: Key('text-widget-key'),
          onVisibilityChanged: (visibilityInfo) {
            bool visible = visibilityInfo.visibleFraction * 100 != 0.0;
            visible == true ? focus.requestFocus() : focus.unfocus();
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(58),
              child: _AppBarNewPost(focus: focus, text: text),
            ),
            body: _StringTextField(focus: focus, text: text),
          ),
        );
      },
      viewModelBuilder: () => CreatePostViewModel(),
    );
  }
}

class _StringTextField extends HookViewModelWidget<CreatePostViewModel> {
  final FocusNode focus;
  final TextEditingController text;
  const _StringTextField({required this.focus, required this.text, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, CreatePostViewModel model) {
    User user = model.user;
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      padding: EdgeInsets.only(top: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.grey[350],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(user.avatar!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  child: DetectableTextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    basicStyle: TextStyle(
                                      fontSize: 18,
                                    ),
                                    decoratedStyle: TextStyle(
                                        fontSize: 18, color: Colors.blue[400]),
                                    detectionRegExp:
                                        detectionRegExp(atSign: false)!,
                                    focusNode: focus,
                                    cursorColor: Colors.blue[400],
                                    controller: text,
                                    maxLength: 200,
                                    maxLines: null,
                                    onChanged: model.updateString,
                                    decoration: InputDecoration(
                                      hintText: 'O que está pipocar? ',
                                      hintStyle: TextStyle(fontSize: 18),
                                      border: InputBorder.none,
                                      counterText: "",
                                    ),
                                  )),
                              // model.gif != null
                              //     ? Container(
                              //         height: 300,
                              //         width: double.infinity,
                              //         color: Colors.grey,
                              //       )
                              //     : Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: MediaQuery.of(context).size.height * .06,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(width: 0.3, color: Colors.grey.shade300))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (model.text.isNotEmpty) {
                          text.clear();
                          model.deleteString();
                        }
                      },
                      child: Container(
                          child: Icon(
                        Icons.delete_rounded,
                        color: model.text.length != 0 ? red : Colors.grey[400],
                        size: 28,
                      )),
                    ),
                    SizedBox(width: 15),
                    //TODO: for later on ability to add gif
                    // GestureDetector(
                    //   child: Container(
                    //       margin: const EdgeInsets.all(5),
                    //       decoration: BoxDecoration(
                    //           border: Border.all(
                    //            color: model.links.isEmpty ? Colors.blue.shade400 : Colors.grey
                    //           ),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(4))),
                    //       child: Icon(
                    //         Icons.gif,
                    //         color: model.links.isEmpty ? Colors.blue.shade400 : Colors.grey
                    //       )),
                    // )
                  ],
                ),
                Container(
                    height: 24,
                    width: 24,
                    child: model.text.isEmpty
                        ? CircularProgressIndicator(
                            strokeWidth: 1.8,
                            backgroundColor: Colors.grey[300],
                            value: 0.0,
                          )
                        : CircularProgressIndicator(
                            strokeWidth: 2.5,
                            backgroundColor: Colors.grey[300],
                            valueColor: model.text.length == 200
                                ? AlwaysStoppedAnimation<Color>(red)
                                : AlwaysStoppedAnimation<Color>(
                                    Colors.blue.shade400),
                            value: model.text.length >= 0
                                ? model.text.length.toDouble() / 200
                                : null))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarNewPost extends ViewModelWidget<CreatePostViewModel> {
  final FocusNode focus;
  final TextEditingController text;
  const _AppBarNewPost({required this.focus, required this.text, Key? key})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, CreatePostViewModel model) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            focus.unfocus();
            text.clear();
            model.deleteString();
            model.setIndex(0);
          },
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
              if (model.text.length > 0 || !model.isBusy) {
                model.addPost();
                focus.unfocus();
                text.clear();
                model.deleteString();
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 13.5),
              width: 80,
              decoration: BoxDecoration(
                color: model.text.length > 0 ? red : Colors.grey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text('Postar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
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
