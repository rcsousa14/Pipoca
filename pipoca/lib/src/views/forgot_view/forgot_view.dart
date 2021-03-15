import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/busy_btn_widget.dart';
import 'package:pipoca/src/constants/widgets/network_sensitive.dart';
import 'package:pipoca/src/views/forgot_view/forgot_view_model.dart';
import 'package:pipoca/src/views/login_view/widgets/form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ForgotView extends StatelessWidget {
  const ForgotView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<ForgotViewModel>.nonReactive(
      builder: (context, model, child) {
        return NetworkSensitive(
          child: Scaffold(
              body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Column(
                children: [
                  SafeArea(
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () => model.goToLogin(),
                              child: Icon(Icons.arrow_back_rounded)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.25,
                  ),
                  _ForgotForm()
                ],
              ),
            ),
          )),
        );
      },
      viewModelBuilder: () => ForgotViewModel(),
    );
  }
}

class _ForgotForm extends HookViewModelWidget<ForgotViewModel> {
  const _ForgotForm({Key key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, ForgotViewModel model) {
    var email = useTextEditingController();
    return Form(
      child: Column(
        children: [
          NewFormTextField(
            focus: true,
            keyboardType: TextInputType.text,
            icon: Icons.email_rounded,
            text: 'Email',
            controller: email,
            formater: FilteringTextInputFormatter.deny(RegExp('[<>]')),
            validator: model.validateEmail,
            textCap: TextCapitalization.none,
            validate: AutovalidateMode.onUserInteraction,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: BusyBtn(
              tap: () => model.access(email: email.text),
              busy: model.isBusy,
              btnColor: orange,
              txtColor: Colors.white,
              text: 'Redefinir Senha',
            ),
          )
        ],
      ),
    );
  }
}
