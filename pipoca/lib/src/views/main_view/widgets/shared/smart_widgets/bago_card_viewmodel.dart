import 'dart:async';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BagoCardViewModel extends ReactiveViewModel {
  //LOCATORS
  final _userService = locator<UserService>();
  final _feedService = locator<FeedService>();
  final _homeNavigator = locator<HomeNavigatorViewModel>();
  final _snackbarService = locator<SnackbarService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final CapturePngService _captureService = locator<CapturePngService>();

  //VARIABLES
  bool? _isUp;
  bool? _isDown;
  late int _totalPoints;

  // GETTERS
  String get creator => _userService.user.username;
  Future get refreshFeed => _homeNavigator.refreshFeed(isRefresh: false);
  bool get filter => _homeNavigator.filter;
  int get page => _homeNavigator.currentPage;
  int? get points => _totalPoints;
  bool? get up => _isUp;
  bool? get down => _isDown;

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
  Future delete({required int id}) async {
    var response = await _bottomSheetService.showBottomSheet(
        cancelButtonTitle: 'Não',
        confirmButtonTitle: 'Sim',
        title: 'Eliminar Bago',
        description: 'Tem certeza de que deseja excluir este bago?');
    if (response?.confirmed == true) {
      _feedService.delete(id);
      var result = await _feedService.deletPost(id: id);

      if (result.status == Status.ERROR) {
        _snackbarService.showSnackbar(message: '${result.message}');
        await refreshFeed;
      }
      if (result.status == Status.COMPLETED) {
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
      _snackbarService.showSnackbar(message: '${result.message}');
      await refreshFeed;
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

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_feedService];
}
