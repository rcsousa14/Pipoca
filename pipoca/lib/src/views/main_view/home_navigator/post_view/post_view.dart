import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/functions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';

class CreatePostView extends StatefulWidget {
  CreatePostView({Key key}) : super(key: key);

  @override
  _CreatePostViewState createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  TextEditingController controller;
  List<String> hashes = [];
  List<String> links = [];
  String content;

  // final List<String> detections =
  //     extractDetections("#Hello World #Flutter Dart #Thank you", hashTagRegExp);

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      hashes = extractDetections(controller.text, hashTagRegExp);
      links = extractDetections(controller.text, urlRegex);
      setState(() {
        content = controller.text;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
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
                  print(hashes);
                  print(links);
                  print(content);
                },
                child: Container(
                  // padding: EdgeInsets.all(4),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  width: 80,
                  decoration: BoxDecoration(
                      color: red, borderRadius: BorderRadius.circular(30)),
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
                    fontWeight: FontWeight.w700))),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                height: MediaQuery.of(context).size.height * .3489993,
                child: DetectableTextField(
                  //TODO: for now at will be false
                  detectionRegExp: detectionRegExp(atSign: false),
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                  basicStyle: TextStyle(fontSize: 18),
                  detectedStyle: TextStyle(fontSize: 18),
                  cursorColor: red,
                  maxLength: 200,
                  maxLines: 5,
                  controller: controller,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 18),
                    hintText: 'O que está a pipocar?',
                    border: InputBorder.none,
                    counterText: "",
                  ),
                )),
            Container(

              padding: EdgeInsets.only(left: 20, right: 20),
              height: MediaQuery.of(context).size.height * .06,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(width: 0.3, color: Colors.grey[350]))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue[400],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: Icon(
                          Icons.gif,
                          color: Colors.blue[400],
                        )),
                  )
                  // Container(
                  //   child: model.text.isEmpty
                  //       ? Container()
                  //       : Text(
                  //           '${model.text.length}' + '/200',
                  //           style: TextStyle(
                  //               color: model.text.length >= 200
                  //                   ? red
                  //                   : Colors.grey[400]),
                  //         ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class PostView extends StatelessWidget {
//  // final PageController controller;

//   const PostView({Key key, }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {

//     return ViewModelBuilder<PostViewModel>.reactive(
//       onModelReady: (model)=> SystemChannels.textInput.invokeMethod('TextInput.show'),
//       builder: (context, model, child) {

//         return Column(
//           children: <Widget>[
//             _AppBarNewPost(

//             ),
//             new _StringTextField(),
//           ],
//         );
//       },
//       viewModelBuilder: () => PostViewModel(),
//     );
//   }
// }

// class _StringTextField extends HookViewModelWidget<PostViewModel> {

//   const _StringTextField({Key key,}) : super(key: key, reactive: true);

//   @override
//   Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
//     final focusNode = useFocusNode();
//     var text = useTextEditingController();
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.only(left: 20, right: 20, top: 15),
//       child: Column(
//         children: <Widget>[
//           Container(
//               padding: EdgeInsets.only(left: 15, right: 16, top: 15),
//               height: MediaQuery.of(context).size.height * .3489993,
//               child: TextField(
//                 focusNode: focusNode,
//                 autofocus: true,
//                 cursorColor: red,
//                 controller: text,
//                 maxLength: 200,
//                 maxLines: null,
//                // autofocus: true,
//                 onChanged: model.updateString,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   counterText: "",
//                 ),
//               )),
//           Container(
//             height: MediaQuery.of(context).size.height * .08,
//             padding: EdgeInsets.all(15),
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 InkWell(
//                   onTap: () {
//                     if (model.text.isNotEmpty) {
//                       text.clear();
//                       model.deleteString();
//                     }
//                   },
//                   child: Container(
//                       child: Text(
//                     'Limpar',
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: model.text.length != 0 ? red : Colors.grey[400],
//                         fontWeight: FontWeight.w500),
//                   )),
//                 ),
//                 Container(
//                   child: model.text.isEmpty
//                       ? Container()
//                       : Text(
//                           '${model.text.length}' + '/200',
//                           style: TextStyle(
//                               color: model.text.length >= 200
//                                   ? red
//                                   : Colors.grey[400]),
//                         ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _AppBarNewPost extends HookViewModelWidget<PostViewModel> {

//   const _AppBarNewPost({Key key})
//       : super(key: key, reactive: false);

//   @override
//   Widget buildViewModelWidget(BuildContext context, PostViewModel model) {
//     return AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: Container(
//             child: Icon(Icons.clear, size: 27),
//           ),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Colors.black),
//         actions: <Widget>[
//           GestureDetector(
//             onTap: () {
//               if (!model.isBusy) {
//                 model.addPost();
//               }
//             },
//             child: Container(
//               margin: EdgeInsets.all(15),
//               width: 80,
//               decoration: BoxDecoration(
//                   color: red, borderRadius: BorderRadius.circular(15)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     PipocaBasics.quill,
//                     size: 12,
//                     color: Colors.white,
//                   ),
//                   SizedBox(
//                     width: 4,
//                   ),
//                   Text('Postar',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500)),
//                 ],
//               ),
//             ),
//           ),
//         ],
//         title: Text('Novo Bago',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700)));
//   }
// }

// class PostViewArguments {
//   final Key key;
//   final NavChoice choice;

//   PostViewArguments({this.key, this.choice});
// }
