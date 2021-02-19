import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/login_view/login_view_model.dart';
import 'package:pipoca/src/views/login_view/widgets/buttons.dart';
import 'package:pipoca/src/views/login_view/widgets/form.dart';
import 'package:pipoca/src/views/login_view/widgets/logo.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
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
    var username = useTextEditingController();
    var phone = useTextEditingController();
    return Form(
      child: Column(
        children: [
          NewFormTextField(
            isPhone: false,
            keyboardType: TextInputType.text,
            icon: FontAwesomeIcons.user,
            text: 'Nome de Usuário',
            controller: username,
            formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
            validator: model.validateUsername,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          NewFormTextField(
            isPhone: true,
            keyboardType: TextInputType.number,
            text: 'Telefone',
            controller: phone,
            formater: FilteringTextInputFormatter.digitsOnly,
            validator: model.validatePhone,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          BusyBtn(
            tap: () => model.signup(username: username.text, phone: phone.text),
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
  const _LoginForm({Key key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, LoginViewModel model) {
    var phone = useTextEditingController();
    return Form(
      child: Column(
        children: [
          NewFormTextField(
            isPhone: true,
            keyboardType: TextInputType.number,
            text: 'Telefone',
            controller: phone,
            formater: FilteringTextInputFormatter.digitsOnly,
            validator: model.validatePhone,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          BusyBtn(
            tap: () => model.login(phone: phone.text),
            busy: model.isBusy,
            color: orange,
            text: 'Login',
          )
        ],
      ),
    );
  }
}
