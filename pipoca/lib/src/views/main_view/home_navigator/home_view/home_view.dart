import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';

import 'package:pipoca/src/constants/widgets/bago_card_widget.dart';
import 'package:pipoca/src/constants/widgets/feed_caller.dart';

import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_list_view.dart';
import 'package:stacked/stacked.dart';


class HomeView extends StatelessWidget {
  final PageController controller;
  const HomeView({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.nonReactive(
      onModelReady: (model) => model.pushFeed(),
 
      disposeViewModel: false,
    
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _Header(
                tap: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            body: BagoListView(choice: model.choice),
            floatingActionButton: HomeFloatingAction(
              action: () => model.goToPost(),
            ));
      },
      viewModelBuilder: () => HomeViewModel(controller: controller),
    );
  }
}

class _Header extends ViewModelWidget<HomeViewModel> {
  final Function tap;
  const _Header({Key key, this.tap}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    User user = model.user.user;
    return HomeAppBar(
      drawer: tap,
      isFilter: model.isFilter,
      filter: () => model.showBasicBottomSheet(
          latest: 'Veja os Bagos mais recentes ⏲️',
          latestD: 'Fique a saber as últimas notícias em sua vizinhança.',
          trending: 'Veja o que esta a Pipocar 🍿',
          trendingD: 'Veja os Bagos que estão a Pipocar em sua vizinhança.'),
      image: user.avatar,
    );
  }
}
