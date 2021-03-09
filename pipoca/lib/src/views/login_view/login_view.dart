import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/login_view/login_view_model.dart';
import 'package:pipoca/src/views/login_view/widgets/buttons.dart';
import 'package:pipoca/src/views/login_view/widgets/form.dart';
import 'package:pipoca/src/views/login_view/widgets/logo.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:pipoca/src/constants/widgets/network_sensitive.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) {
   
        return NetworkSensitive(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Stack(
                children: [
                  GestureDetector(onVerticalDragUpdate: (_) {}, child: Logo()),
                  FormBuilder(
                    currentIndex: model.currentIndex,
                    setIndex: model.setIndex,
                    login: _LoginForm(),
                    signup: _SignUpForm(),
                    termsTap: () => print('hi'),
                  )
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

class _SignUpForm extends HookViewModelWidget<LoginViewModel> {
  const _SignUpForm({Key key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    var email = useTextEditingController();
    var password = useTextEditingController();
    return Form(
      child: Column(
        children: [
          NewFormTextField(
            keyboardType: TextInputType.text,
            icon: Icons.email_rounded,
            text: 'Email',
            controller: email,
            formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
            validator: model.validateEmail,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          NewFormTextField(
            isPassword: true,
            icon: Icons.lock_rounded,
            keyboardType: TextInputType.text,
            text: 'Senha',
            controller: password,
            formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
            validator: model.validatePass,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          BusyBtn(
            tap: () => model.access(
                email: email.text,
                password: password.text,
                type: 'email/password'),
            busy: model.isBusy,
            color: orange,
            text: 'Inscrever-se',
          )
        ],
      ),
    );
  }
}

class _LoginForm extends HookViewModelWidget<LoginViewModel> {
  const _LoginForm({Key key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    var email = useTextEditingController();
    var password = useTextEditingController();
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          NewFormTextField(
            keyboardType: TextInputType.text,
            icon: Icons.email_rounded,
            text: 'Email',
            controller: email,
            formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
            validator: model.validateEmail,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          NewFormTextField(
            isPassword: true,
            icon: Icons.lock_rounded,
            keyboardType: TextInputType.text,
            text: 'Senha',
            controller: password,
            formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
            validator: model.validatePass,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 5),
            child: Text(
              'Esqueceu a senha?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          BusyBtn(
            tap: () => model.access(
                email: email.text,
                password: password.text,
                type: 'email/password'),
            busy: model.isBusy,
            color: orange,
            text: 'Login',
          )
        ],
      ),
    );
  }
}
