import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';
import 'package:pipoca/src/views/main_view/widgets/shared/smart_widgets/bago_list_view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends HookWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scrollController = useScrollController();

    return ViewModelBuilder<HomeViewModel>.reactive(
   
      fireOnModelReadyOnce: true,
      onModelReady: (model) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
      },
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: GestureDetector(
                  onTap: () => scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      ),
                  child: _Header(tap: () => Scaffold.of(context).openDrawer())),
            ),
            body: BagoListView(
              controller: scrollController,
            ),
            floatingActionButton:
                HomeFloatingAction(action: () => model.setIndex(1)));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class _Header extends ViewModelWidget<HomeViewModel> {
  final Function tap;
  const _Header({Key? key, required this.tap})
      : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, HomeViewModel model) {
    User user = model.user;
    return HomeAppBar(
      drawer: tap,
      isFilter: model.filter,
      filter: () => model.showBasicBottomSheet(
          latest: 'Veja os Bagos mais recentes ⏲️',
          latestD: 'Fique a saber as últimas notícias em sua vizinhança.',
          trending: 'Veja o que esta a Pipocar 🍿',
          trendingD: 'Veja os Bagos que estão a Pipocar em sua vizinhança.'),
      image: user.avatar,
    );
  }
}
