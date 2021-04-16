import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/views/login_view/login_view_model.dart';
import 'package:pipoca/src/views/login_view/widgets/form.dart';
import 'package:pipoca/src/views/login_view/widgets/logo.dart';
import 'package:stacked/stacked.dart';

import 'package:pipoca/src/constants/widgets/network_sensitive.dart';

class LoginView extends StatelessWidget {
  final String message;
  const LoginView({Key? key, this.message = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) {
        if (message.isNotEmpty) {
          model.showError(message);
        }
      },
      builder: (context, model, child) {
        Widget loadingIndicator = model.isBusy
            ? new Container(
                color: Colors.black.withOpacity(0.6),
                width: width,
                height: height,
                child: new Center(
                    child: Platform.isIOS
                        ? Container(
                            height: 60,
                            width: 65,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: CupertinoActivityIndicator(
                              radius: 10,
                            ),
                          )
                        : CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )),
              )
            : new Container();

        return NetworkSensitive(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: height,
                color: Colors.white,
                child: Stack(
                  children: [
                    Logo(),
                    FormBuilder(
                      isBusy: model.isBusy,
                      fbTap: () => model.facebook().then((value) {
                        if (value is UserAuth) {
                          model.getToken(value);
                        }
                      }),
                      glTap: () => model.google().then((value) {
                        if (value is UserAuth) {
                          model.getToken(value);
                        }
                      }),
                      apTap: () => print('apple'),
                      termsTap: () => print('hello'),
                    ),
                    new Align(
                      child: loadingIndicator,
                      alignment: FractionalOffset.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      //TODO: to be implement outside of heroku login and signup with email/password
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

// class _SignUpForm extends HookViewModelWidget<LoginViewModel> {
//   const _SignUpForm({Key key}) : super(key: key);

//   @override
//   Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
//     var email = useTextEditingController();
//     var password = useTextEditingController();
//     return Form(
//       child: Column(
//         children: [
//           NewFormTextField(
//             keyboardType: TextInputType.text,
//             icon: Icons.email_rounded,
//             text: 'Email',
//             controller: email,
//             formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
//             validator: model.validateEmail,
//             textCap: TextCapitalization.none,
//             validate: AutovalidateMode.onUserInteraction,
//           ),
//           NewFormTextField(
//             isPassword: true,
//             icon: Icons.lock_rounded,
//             keyboardType: TextInputType.text,
//             text: 'Senha',
//             controller: password,
//             formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
//             validator: model.validatePass,
//             textCap: TextCapitalization.none,
//             validate: AutovalidateMode.onUserInteraction,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
//             child: BusyBtn(
//               tap: () => model.access(
//                   email: email.text, password: password.text, type: 'signup'),
//               busy: model.isBusy,
//               btnColor: orange,
//               txtColor: Colors.white,
//               text: 'Inscrever-se',
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class _LoginForm extends HookViewModelWidget<LoginViewModel> {
//   const _LoginForm({Key key}) : super(key: key, reactive: true);

//   @override
//   Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
//     var email = useTextEditingController();
//     var password = useTextEditingController();
//     return Form(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           NewFormTextField(
//             keyboardType: TextInputType.text,
//             icon: Icons.email_rounded,
//             text: 'Email',
//             controller: email,
//             formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
//             validator: model.validateEmail,
//             textCap: TextCapitalization.none,
//             validate: AutovalidateMode.onUserInteraction,
//           ),
//           NewFormTextField(
//             isPassword: true,
//             icon: Icons.lock_rounded,
//             keyboardType: TextInputType.text,
//             text: 'Senha',
//             controller: password,
//             formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
//             validator: model.validatePass,
//             textCap: TextCapitalization.none,
//             validate: AutovalidateMode.onUserInteraction,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical:8.0, horizontal: 25),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//               onTap: () => model.forgot(),
//               child: Text(
//                 'Esqueceu a senha?',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
//               ),
//             ),
//             BusyBtn(
//               tap: () => model.access(
//                   email: email.text, password: password.text, type: 'login'),
//               busy: model.isBusy,
//               btnColor: Colors.black,
//               txtColor: Colors.white,
//               text: 'Login',
//             )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
