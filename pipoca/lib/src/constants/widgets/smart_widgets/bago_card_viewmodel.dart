import 'dart:async';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/caller.service.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BagoCardViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();

  final _location = locator<LocationService>();
  final _callerService = locator<CallerService>();
  final _snackbarService = locator<SnackbarService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final CapturePngService _captureService = locator<CapturePngService>();

  String get creator => _userService.user.username;
  bool? _isUp;
  bool? _isDown;
  late int _totalPoints;
  int? get points => _totalPoints;
  bool? get up => _isUp;
  bool? get down => _isDown;

  void getVote(bool isVoted, int vote, int points) {
    _totalPoints = points;
    if (isVoted == true) {
      if (vote == -1) {
        _isUp = false;
        _isDown = true;
        notifyListeners();
      } else {
        _isUp = true;
        _isDown = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future delete(
      {required int id, required int page, required bool filter}) async {
    var response = await _bottomSheetService.showBottomSheet(
        cancelButtonTitle: 'Não',
        confirmButtonTitle: 'Sim',
        title: 'Eliminar Bago',
        description: 'Tem certeza de que deseja excluir este bago?');
    if (response?.confirmed == true) {
      print('yes');
      _feedService.delete(id);
      var result = await _feedService.deletPost(id: id);

      if (result.status == Status.ERROR) {
        return _snackbarService.showSnackbar(message: '${result.message}');
      }
      if (result.status == Status.COMPLETED) {
        int level = await _callerService.batteryLevel();
           print('yes completed');
        await _callerService.battery(
            level,
            _feedService.fetchFeed(
              info: FeedInfo(
                coordinates: Coordinates(
                    latitude: _location.currentLocation.latitude,
                    longitude: _location.currentLocation.longitude),
                page: page == 1 ? page : 1,
                filter: filter == false ? 'date' : 'pipocar',
              ),
              isRefresh: false,
            ));
            notifyListeners();
      }
    }
  }

  Future vote({
    required int id,
    required int vote,
    required bool isVoted,
    required bool filter,
    required int page,
    required int points,
  }) async {
    if (vote == -1) {
      if (points == 0 && isVoted == true ||
          points == 1 && isVoted == true ||
          points == 0 && isVoted == false) {
        _totalPoints = vote;
      } else {
        --_totalPoints;
        notifyListeners();
      }

      _isUp = false;
      _isDown = true;
      notifyListeners();
    } else {
      if (points == 0 && isVoted == true ||
          points == -1 && isVoted == true ||
          points == 0 && isVoted == false) {
        _totalPoints = vote;
        notifyListeners();
      } else {
        ++_totalPoints;
        notifyListeners();
      }

      _isUp = true;
      _isDown = false;
      notifyListeners();
    }

    var result =
        await _feedService.pointPost(point: PostPoint(postId: id, voted: vote));

    if (result.status == Status.ERROR) {
      return _snackbarService.showSnackbar(message: '${result.message}');
    }
    if (result.status == Status.COMPLETED) {
      int level = await _callerService.batteryLevel();
      await _callerService.battery(
          level,
          _feedService.fetchFeed(
            info: FeedInfo(
              coordinates: Coordinates(
                  latitude: _location.currentLocation.latitude,
                  longitude: _location.currentLocation.longitude),
              page: page == 1 ? page : 1,
              filter: filter == false ? 'date' : 'pipocar',
            ),
            isRefresh: false,
          ));
    }
  }

  Future share(key) async {
    return await _captureService.capturePng(key);
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
