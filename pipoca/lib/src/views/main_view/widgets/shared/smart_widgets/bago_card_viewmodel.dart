import 'dart:async';
import 'dart:convert';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BagoCardViewModel extends StreamViewModel<ApiResponse<SinglePost>> {
  //LOCATORS
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();
  final _homeNavigator = locator<HomeNavigatorViewModel>();
  final _snackbarService = locator<SnackbarService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _locationService = locator<LocationService>();
  final CapturePngService _captureService = locator<CapturePngService>();

  //VARIABLES
  bool? _isVisible;
  bool? _isUp;
  bool? _isDown;
  late int _totalPoints;

  // GETTERS

  String get creator => _userService.user.username;
  bool get filter => _homeNavigator.filter;
  Future get refreshFeed => _homeNavigator.refreshFeed(isRefresh: true);
  int get page => _homeNavigator.currentPage;
  int? get points => _totalPoints;
  bool get isVisible => _isVisible!;
  bool? get up => _isUp;
  bool? get down => _isDown;

  void changeVisibility(bool visible) {
    _isVisible = visible;
    notifyListeners();
  }

//FUNCTION TO THE INITIAL VOTE FROM THE FEEDS POST
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

//FUTURE TO DELETE POST
  Future delete({required int id, required bool isSingle}) async {
    var response = await _bottomSheetService.showBottomSheet(
        cancelButtonTitle: 'Não',
        confirmButtonTitle: 'Sim',
        title: 'Eliminar Bago',
        description: 'Tem certeza de que deseja excluir este bago?');
    if (response?.confirmed == true) {
      var result = await _feedService.deletPost(id: id);

      if (result.status == Status.ERROR) {
        await refreshFeed;
        _snackbarService.showSnackbar(message: '${result.data!.message}');
        
      }
      if (result.status == Status.COMPLETED) {
        _feedService.delete(id, isSingle);
        await refreshFeed;
      }
    }
  }

//FUTURE TO MAKE A VOTE
  Future vote({
    required int id,
    required int vote,
    required bool isVoted,
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

    var result = await _feedService.pointPost(
        point: PostPoint(
          postId: id,
          voted: vote,
        ),
        filter: filter == false ? 'date' : 'pipocar');

    if (result.status == Status.ERROR) {
      await refreshFeed;
      _snackbarService.showSnackbar(message: 'Tenta Novamente');
     
    }
    if (result.status == Status.COMPLETED) {
      await refreshFeed;
      

    }
    notifyListeners();
  }

  //FUTURE TO SHARE POST
  Future share(key) async {
    return await _captureService.capturePng(key);
  }

  //FUTURE TO CALL SINGULAR POST
  Future<ApiResponse<SinglePost>> fetchSingle({required int id}) async {
    var result = await _feedService.singlePost(
        info: PostInfo(coordinates: _locationService.currentLocation, id: id));
    if (result.status == Status.COMPLETED) {
      // getVote(result.data!.data!.userVoted!, result.data!.data!.userVote!,
      //     result.data!.data!.info!.votesTotal);
    }

    return result;
  }

  @override
  Stream<ApiResponse<SinglePost>> get stream => _feedService.singleStream;
}
