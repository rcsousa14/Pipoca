import 'package:flutter/foundation.dart';

class Usuario {
  final String id;
  final String email;
  final String dob;
  final String gender;
  final String userPicture;
  final String userName;
  final String userRole;
  final int totalPoints;
  final int wallet;
  final String createdDate;
  final String updatedDate;

  Usuario(
      {this.dob,
      @required this.id,
      this.createdDate,
      this.updatedDate,
      this.email,
      this.wallet,
      this.gender,
      this.userName,
      this.userPicture,
      this.totalPoints = 0,
      this.userRole = "basic"});

  Usuario.fromData(Map<String, dynamic> data)
      : email = data['email'],
        dob = data['dob'],
        createdDate = data['createdDate'],
        updatedDate = data['updatedDate'],
        id = data['id'],
        gender = data['gender'],
        wallet = data['wallet'],
        totalPoints = data['totalPoints'],
        userPicture = data['userPicture'],
        userName = data['userName'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'dob': dob,
      'id': id,
      'wallet': wallet, 
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'gender': gender,
      'userPicture': userPicture,
      'userName': userName,
      'totalPoints': totalPoints,
      'userRole': userRole,
    };
  }
}
