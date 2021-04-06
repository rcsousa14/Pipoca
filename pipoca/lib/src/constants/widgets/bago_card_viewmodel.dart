import 'package:flutter/widgets.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/repositories/feed/post_point_repository.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/social_share_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BagoCardViewModel extends BaseViewModel {
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final CapturePngService _captureService = locator<CapturePngService>();
  final UrlLancherService _lancherService = locator<UrlLancherService>();
  final PostPointRepository _pointRepository = locator<PostPointRepository>();

  Future vote({@required int id, int vote}) async {
    var result = await _pointRepository.postPoint(id.toString(), vote.toString());
    if (result != 200) {
      _snackbarService.showSnackbar(message: "slow it down");
    }
  }

  

  Future share(key) async {
    return await _captureService.capturePng(key);
  }

  Future social(uri) async {
    return await _lancherService.social(uri);
  }

//TODO: navigation to the next page
  // Future<dynamic> selected({int ofBagoIndex}) {
  //   return _navigationService.navigateTo('/post/:id',
  //       arguments: PostsViewArguments(
  //         bagoIndex: ofBagoIndex,
  //       ),
  //       id: 1);
  // }
}
