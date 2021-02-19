// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pipoca/src/app/locator.dart';
// import 'package:pipoca/src/constants/routes/navigation.dart';
// import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
// import 'package:pipoca/src/models/post_model.dart';
// import 'package:pipoca/src/models/user_model.dart';
// import 'package:pipoca/src/services/authentication_service.dart';
// import 'package:pipoca/src/services/firestore_service.dart';
// import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view.dart';
// import 'package:stacked/stacked.dart';
// import 'package:stacked_services/stacked_services.dart';

// class HomeViewModel extends BaseViewModel {
//   final AuthenticationService _authenticationService =
//       locator<AuthenticationService>();
//   final FirestoreService _firestoreService = locator<FirestoreService>();
//   final NavigationService _navigationService = locator<NavigationService>();
//   final DialogService _dialogService = locator<DialogService>();

//   List<Post> _bagos;
//   List<Post> get bagos => _bagos;
//   int _currentIndex = 0;
//   int get currentIndex => _currentIndex;

//   Usuario get user => _authenticationService.currentUser;

//   NavChoice get choice => NavChoice.home;
//   get choicePage => NavChoice.home.pageStorageKey();
//   Future fetchPosts(GeoPoint point) async {
//     setBusy(true);
//     var postResults = await _firestoreService.getPost(point:point, orderBy: "createdDate");
//     if (postResults is List<Post>) {
//       _bagos = postResults;
//       notifyListeners();
//     } else {
//       await _dialogService.showDialog(
//           title: 'no post', description: 'load again');
//     }
//     setBusy(false);
//   }

//   Future<dynamic> goToPost(NavChoice choice) {
//     return _navigationService.navigateTo(postRoute,
//         arguments: PostViewArguments(choice: choice),
//         id: choice.nestedKeyValue());
//   }
// }
