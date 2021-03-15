import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/busy_btn_widget.dart';

class NewFormTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final IconData icon;
  final String text;
  final TextEditingController controller;
  final Function validator;
  final FilteringTextInputFormatter formater;
  final bool focus;
  final bool isPassword;
  final AutovalidateMode validate;
  final TextCapitalization textCap;
  const NewFormTextField(
      {Key key,
      this.keyboardType,
      this.icon,
      this.isPassword = false,
      this.text,
      this.controller,
      this.validator,
      this.validate,
      this.focus = false,
      this.formater,
      this.textCap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TextFormField(
        style: TextStyle(fontSize: 14.5, color: Colors.grey[850]),
        obscureText: isPassword ? true : false,
        autofocus: focus,
        autovalidateMode: validate,
        textCapitalization: textCap,
        inputFormatters: [formater],
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            errorBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[300]),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: orange),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            prefixIcon: Icon(
              icon,
              size: 18,
              color: Colors.black,
            ),
            errorStyle: TextStyle(fontSize: 12, color: red),
            prefixStyle: TextStyle(fontSize: 12, color: red),
            // prefixText: isPhone == true? '+244 ' : null,
            hintText: text,
            hintStyle: TextStyle(fontSize: 14.5, color: Colors.grey[600])),
      ),
    );
  }
}

class FormBuilder extends StatelessWidget {
  final bool isBusy;
  final Function fbTap;
  final Function glTap;
  final Function apTap;

  final Function termsTap;
  const FormBuilder(
      {Key key, this.apTap, this.fbTap, this.glTap, this.isBusy, this.termsTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height * 0.5,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 35, left: 60, right: 60),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [red, orange],
            ),
            borderRadius:
                BorderRadius.only(topRight: const Radius.circular(65))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: !Platform.isIOS? const EdgeInsets.only(top: 20, bottom: 30):const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Login via mídia social',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300),
              ),
            ),
            BusyBtnLogin(
              busy: isBusy,
              btnColor: facebookBtn,
              icon: Icon(
                FontAwesomeIcons.facebookF,
                size: 22,
              ),
              text: 'Continua com Facebook',
              tap: fbTap,
            ),
            BusyBtnLogin(
              busy: isBusy,
              btnColor: Colors.white,
              txtColor: Colors.grey[700],
              icon: SvgPicture.asset(
                'images/google.svg',
                width: 25,
                height: 18,
              ),
              text: 'Continua com Google',
              tap: glTap,
            ),
            !Platform.isIOS ? Container(
              height: height * 0.06,
            ):
            BusyBtnLogin(
              busy: isBusy,
              btnColor: Colors.black,
              icon: Icon(
                FontAwesomeIcons.apple,
                size: 22,
              ),
              text: 'Continua com Apple',
              tap: apTap,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Clicando, concordas com nossos',
                    style: TextStyle(color: Colors.white, fontSize: 13.5),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Termos e Condições',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.5,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = termsTap)
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tabs extends StatelessWidget {
  final Widget signup;
  final Widget login;
  final int currentIndex;
  final Function(int) setIndex;
  const Tabs(
      {Key key, this.login, this.signup, this.currentIndex, this.setIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      initialIndex: currentIndex,
      child: Column(
        children: [
          PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                child: TabBar(
                  physics: BouncingScrollPhysics(),
                  onTap: setIndex,
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(width: 3.0, color: Colors.transparent),
                      insets: EdgeInsets.only(
                          left: currentIndex == 0 ? 40.0 : 62.0,
                          right: currentIndex == 0 ? 60.0 : 54.0)),
                  indicatorColor: orange,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'roboto',
                      fontWeight: FontWeight.bold),
                  tabs: [
                    Container(height: 30.0, child: Tab(text: 'Login')),
                    Container(
                      height: 30.0,
                      child: Tab(text: 'Inscrever'),
                    ),
                  ],
                ),
              )),
          SizedBox(height: height * 0.005),
          Divider(
            thickness: 0.65,
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                      child: Center(
                        child: login,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )),
                        child: signup),
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
