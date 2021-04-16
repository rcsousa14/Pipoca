import 'package:flutter/material.dart';
import 'package:pipoca/src/views/intro_view/intro_view_model.dart';
import 'package:stacked/stacked.dart';

class IntroView extends StatelessWidget {
  const IntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<IntroViewModel>.reactive(
      builder: (context, model, child) {
        return Container();
        // return Scaffold(
        //     body: Container(
        //   padding: const EdgeInsets.all(35),
        //   decoration:  BoxDecoration(
        //       gradient:  LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomLeft,
        //     colors: [
        //       red,
        //       orange
        //     ],
        //   )),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       text(
        //         text: 'HABILITAR LOCALIZAÇÃO',
        //         weight: FontWeight.bold,
        //         color: white,
        //         size: 27,
        //       ),
        //       SizedBox(
        //         height: height * .03,
        //       ),
        //       text(
        //         text:
        //             'Pipoca usa localização para mostrar fluxo de mensagens de qualidade em sua área. Para fazer isso, você precisa nos dar permissão para usar sua localização.',
        //         weight: FontWeight.bold,
        //         color: white,
        //         size: 16,
        //       ),
        //       Container(
        //           margin: const EdgeInsets.symmetric(vertical: 10),
        //           height: height * .39,
        //           child: SvgPicture.asset('images/location.svg')),
        //       SizedBox(
        //         height: height * .04,
        //       ),
        //       Container(
        //           margin: const EdgeInsets.symmetric(vertical: 15),
        //           height: height * .05,
        //           width: width * 0.55,
        //           child: BusyBtn(
        //             text: 'FIXE!',
        //             btnColor: Colors.white,
        //             txtColor: Colors.black,
        //             tap: () => model.locationCheck(),
        //             busy: model.isBusy,
        //           ))
        //     ],
        //   ),
        // ));
      },
      viewModelBuilder: () => IntroViewModel(),
    );
  }
}

// text({String text, double size, Color color, FontWeight weight}) {
//   return Text(
//     text,
//     textAlign: TextAlign.center,
//     style: TextStyle(
//       fontWeight: weight,
//       color: color,
//       fontSize: size,
//     ),
//   );
// }
