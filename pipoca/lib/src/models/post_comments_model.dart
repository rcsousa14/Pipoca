import 'package:pipoca/src/models/user_feed_model.dart';

class Comentario {
  bool? success;
  String? message;
  Bagos? bagos;

  Comentario({this.success, this.message, this.bagos});

  Comentario.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    bagos = new Bagos.fromJson(json['bagos']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;

   data['bagos'] = this.bagos!.toJson();

    return data;
  }
}


