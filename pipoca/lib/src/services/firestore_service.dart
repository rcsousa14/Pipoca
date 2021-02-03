import 'package:flutter/foundation.dart';
import 'package:maps_toolkit/maps_toolkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/models/post_model.dart';
import 'package:pipoca/src/models/user_model.dart';

@lazySingleton
class FirestoreService {
  final CollectionReference _userCollectionReference =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _postCollectionReference =
      FirebaseFirestore.instance.collection("posts");
  Future createUser(Usuario user) async {
    try {
      await _userCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      return e;
    }
  }

  Future getUser(String uid) async {
    try {
      var data = await _userCollectionReference.doc(uid).get();
      if (data.exists) {
        Usuario user = Usuario.fromData(data.data());
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return e;
    }
  }

  Future addPost(Post post) async {
    try {
      await _postCollectionReference.add(post.toJson());
    } catch (e) {
      return e;
    }
  }

  Future getPost({GeoPoint point, @required String orderBy}) async {
    try {
      var data = await _postCollectionReference
          .orderBy(orderBy, descending: true)
          .get();

      if (data.docs.isNotEmpty) {
        return data.docs.map((e) => Post.fromData(e.data())).where((element) {
          var distance = SphericalUtil.computeDistanceBetween(
              LatLng(point.latitude, point.longitude),
              LatLng(element.geopoint.latitude, element.geopoint.longitude));
          double km = distance / 1000;
          print(km);
          return km <= 8.04672;
        }).toList();
      }
    } catch (e) {
      return e;
    }
  }
}
