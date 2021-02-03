import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Post {
  final String userId;
  final String createdDate;
  final GeoPoint geopoint;
  final String address; 
  final int points;
  final String post;
  final int commentsTotal;

  Post(
      {@required this.userId,
      @required this.createdDate,
      this.address,
      this.points = 0,
      @required this.geopoint,
      @required this.commentsTotal,
      @required this.post});

  Post.fromData(Map<String, dynamic> data)
      : userId = data['userId'],
      address = data['address'],
        createdDate = data['createdDate'],
        geopoint = data['geopoint'],
        points = data['points'],
        post = data['post'],
        commentsTotal = data['commentsTotal'];
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'createdDate': createdDate,
      'geopoint': geopoint,
      'address': address, 
      'points': points,
      'post': post,
      'commentsTotal': commentsTotal
    };
  }
}



