import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pipoca/src/constants/themes/colors.dart';


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
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            errorBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[300]),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: orange),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
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
  final Widget signup;
  final Widget login;
  final int currentIndex;
  final Function(int) setIndex;
  final Function termsTap;
  const FormBuilder(
      {Key key,
      this.currentIndex,
      this.setIndex,
      this.login,
      this.signup,
      this.termsTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Positioned(
      top: height * 0.315,
      right: width * 0.15,
      left: width * 0.15,
      child: Column(
        children: [
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: width * 0.75,
              height: height * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Tabs(
                currentIndex: currentIndex,
                setIndex: setIndex,
                signup: signup,
                login: login,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Clicando, concordas com nossos',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' Termos e Condições',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = termsTap)
                  ]),
            ),
          ),
        ],
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
