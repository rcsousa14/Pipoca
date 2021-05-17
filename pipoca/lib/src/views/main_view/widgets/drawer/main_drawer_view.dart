import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/models/list_data_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/main_view/widgets/drawer/main_drawer_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:timeago/timeago.dart' as timeago;

class MainDrawerView extends StatelessWidget {
  const MainDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return ViewModelBuilder<MainDrawerViewModel>.reactive(
      initialiseSpecialViewModelsOnce: true,
      disposeViewModel: false,
      builder: (context, model, child) {
        return SizedBox(
          width: width * .7,
          child: Drawer(
            child: Container(
              width: width * .65,
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                      width: width * .65,
                      height: height * .3,
                      child: _DrawerHeader()),
                  SizedBox(width: width * .65, child: drawerList()),
                  SizedBox(
                    height: height * .36,
                  ),
                  SizedBox(
                      width: width * .65,
                      child: Divider(
                        color: Colors.grey[300],
                      )),
                  SizedBox(
                    width: width * .65,
                    child: ListTile(
                      onTap: () => model.logout(),
                      dense: true,
                      trailing: Icon(
                        Icons.logout,
                        color: Colors.grey[400],
                      ),
                      title: model.isBusy
                          ? Container(
                              height: 20,
                              width: 20,
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      child: CircularProgressIndicator()),
                                  Expanded(child: Container())
                                ],
                              ))
                          : Text(
                              'Logout',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => MainDrawerViewModel(),
    );
  }
}

class _DrawerHeader extends ViewModelWidget<MainDrawerViewModel> {
  const _DrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, MainDrawerViewModel model) {
    User user = model.user;
    timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());

    final time = DateTime.parse(user.createdAt);
    return DrawerHeader(
        child: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          avatar(user.avatar),
          account(
              username: user.username,
              tap: () => print('hi'),
              date: timeago.format(time, locale: 'pt_BR_short'),
              karma: user.karmaTotal >= 1000
                  ? toCurrencyString('${user.karmaTotal}',
                      shorteningPolicy: ShorteningPolicy.Automatic)
                  : user.karmaTotal.toString())
        ],
      ),
    ));
  }
}

Widget drawerList() {
  List<ListData> data = [
    ListData(icon: Icon(PipocaBasics.user), text: 'Perfil'),
    ListData(icon: Icon(PipocaBasics.history), text: 'História'),
    ListData(
        icon: Icon(
          FontAwesomeIcons.solidHeart,
          color: red,
        ),
        text: 'Partilhar o App'),
  ];
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (context, index) => ListTile(
      dense: true,
      onTap: () => print('hi'),
      leading: data[index].icon,
      title: Align(
        alignment: Alignment(-1.3, 0),
        child: Text(
          data[index].text!,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 15.5),
        ),
      ),
    ),
  );
}

Widget avatar(image) {
  return Image.network(image, frameBuilder: (BuildContext context, Widget child,
      int? frame, bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(45),
          ),
          child:
              ClipRRect(borderRadius: BorderRadius.circular(45), child: child));
    }
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(45),
        child: AnimatedOpacity(
          child: child,
          opacity: frame == null ? 0 : 1,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        ),
      ),
    );
  });
}

Widget account(
    {required String username,
    required Function tap,
    required String karma,
    required String date}) {
  return Column(
    children: [
      GestureDetector(
        onTap: () => tap,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 26),
          child: Text(
            '@$username',
            style: TextStyle(fontSize: 15.5),
          ),
        ),
      ),
      Container(
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon(
                  icon: Icon(
                    PipocaBasics.dharma_wheel,
                    color: orange,
                  ),
                  text: 'Karma',
                  txtNum: karma.toString()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: VerticalDivider(
                  width: 10,
                  color: Colors.grey[300],
                ),
              ),
              icon(
                  icon: Icon(
                    PipocaBasics.party,
                    color: orange,
                  ),
                  text: 'Aniversário',
                  txtNum: date.toString()),
            ],
          ),
        ),
      )
    ],
  );
}

Widget icon({Icon? icon, String? text, String? txtNum}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      icon!,
      SizedBox(
        width: 8,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            txtNum!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            text!,
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      )
    ],
  );
}
