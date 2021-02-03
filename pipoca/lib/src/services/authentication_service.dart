import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/firestore_service.dart';

@lazySingleton
class AuthenticationService {
  final _firestoreService = locator<FirestoreService>();
  final _auth = FirebaseAuth.instance;
  final _fb = FacebookLogin();
  final _google = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile'
  ]);

  Usuario _currentUser;
  Usuario get currentUser => _currentUser;

  Future loginWithFB() async {
    final res = await _fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
      FacebookPermission.userGender,
      FacebookPermission.userBirthday,
    ]);
    switch (res.status) {
      case FacebookLoginStatus.success:
        final response = await http.get(
            'https://graph.facebook.com/v9.0/me?fields=id,picture.height(200),email,gender,birthday&access_token=${res.accessToken.token}');
        final profile = jsonDecode(response.body);

        final FacebookAuthCredential credential =
            FacebookAuthProvider.credential(res.accessToken.token);
        var authResult = await _auth.signInWithCredential(credential);

        var fsResult = await _firestoreService.getUser(authResult.user.uid);
        if (fsResult == null) {
          _currentUser = Usuario(
            id: authResult.user.uid,
            email: authResult.user.email,
            userName: authResult.user.displayName,
            gender: profile['gender'],
            dob: profile['birthday'],
            userPicture: profile['picture']['data']['url'],
            createdDate: DateTime.now().toString(),
            updatedDate: DateTime.now().toString(),
          );

          await _firestoreService.createUser(_currentUser);
        } else {
          await _populateCurrentUser(authResult.user);
        }

        return authResult.user != null;
      case FacebookLoginStatus.cancel:
        return FacebookError(
            localizedTitle: 'Login',
            localizedDescription:
                'A função de login foi cancelada pelo usuário');
        break;
      case FacebookLoginStatus.error:
        return FacebookError(
            localizedTitle: 'Login',
            localizedDescription: 'Verifique sua conexão de internet');
        break;
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount res = await _google.signIn();
      final GoogleSignInAuthentication googleAuth = await res.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    
    
      var authResult = await _auth.signInWithCredential(credential);
      var fsResult = await _firestoreService.getUser(authResult.user.uid);
    
      if (fsResult == null) {

        _currentUser = Usuario(
          id: authResult.user.uid,
          email: authResult.user.email,
          userName: authResult.user.displayName,
          userPicture: authResult.user.photoURL,
          createdDate: DateTime.now().toString(),
          updatedDate: DateTime.now().toString(),
        );

          await _firestoreService.createUser(_currentUser);
      } else {
         await _populateCurrentUser(authResult.user);
      }

      return authResult.user != null;
    } catch (e) {
      return e;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = _auth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);
    }
  }

  Future signout() async {
    await _auth.signOut();
    await _fb.logOut();
  }
}
