import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/create_post_view/create_post_view.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/widgets/bago_list_view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeView({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ));
       model.pushFeed();
      },
      builder: (context, model, child) {
        return Scaffold(
         
            backgroundColor: Colors.blueGrey[50],
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _Header(tap: () => Scaffold.of(context).openDrawer()),
            ),
            body: BagoListView(),
            floatingActionButton: HomeFloatingAction(
                action: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreatePostView(
                        filter: model.filter,
                        index: model.index,
                      ),
                    ))));
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
