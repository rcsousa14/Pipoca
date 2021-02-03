import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/bago_card_widget.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view_widgets.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<GeoPoint>(context, listen: true);
    //TODO: need to separate the reactive with the non's
    return ViewModelBuilder<HomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.fetchPosts(userLocation),
      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: HomeAppBar(
                  drawer: () => print('drawer'),
                  filter: () => print('filter'),
                  image: model.user.userPicture,
                )),
            body: model.bagos != null
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: model.bagos.length,
                    itemBuilder: (context, index) {
                      return BagoCard(
                        choice: model.choice,
                        bagoIndex: index,
                        text: model.bagos[index].post,
                        date: model.bagos[index].createdDate,
                        points: model.bagos[index].points,
                      );
                    })
                : Center(child: CircularProgressIndicator()),
            floatingActionButton: HomeFloatingAction(
              action: () => model.goToPost(model.choice),
            ));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
