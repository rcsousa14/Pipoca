import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_view_model.dart';
import 'package:stacked/stacked.dart';

class BagoView extends StatelessWidget {
  final CheckData data;
  const BagoView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BagoViewModel>.reactive(
        builder: (context, model, child) {
          return FeedCaller(
            itemCreated: () => model.checkDate(data),
            child: model.matches == false && model.checkNew.content.isNotEmpty
                ? Align(
                    alignment: Alignment.topCenter,
                    child: AnimatedOpacity(
                      opacity: model.checkNew.content.isNotEmpty ? 1 : 0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        margin: model.checkNew.content.isNotEmpty ? EdgeInsets.only(top:2): EdgeInsets.only(top:4),
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            'Novos Bagos',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ))
                : Container(),
          );
        },
        viewModelBuilder: () => BagoViewModel());
  }
}
