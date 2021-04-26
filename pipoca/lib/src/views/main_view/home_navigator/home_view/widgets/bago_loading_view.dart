import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/helpers/feed_caller.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_loading_view_model.dart';
import 'package:stacked/stacked.dart';

class BagoView extends StatelessWidget {
  const BagoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BagoViewModel>.reactive(
        builder: (context, model, child) {
         return model.dataReady && model.data == true ? FeedCaller(
            itemCreated: () => model.startTimer(),
            child: Align(
              alignment: Alignment.topCenter,
              child: LinearProgressIndicator(
                value: model.value,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
              ),
            ),
          )
           : Container();
        },
        viewModelBuilder: () => BagoViewModel());
  }
}
