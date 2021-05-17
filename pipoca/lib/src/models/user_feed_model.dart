import 'package:pipoca/src/models/user_location_model.dart';

class FeedInfo {
  Coordinates? coordinates;
  String? filter;
  int page;

  FeedInfo({this.coordinates, this.filter, required this.page});
}

class PostInfo {
  late Coordinates coordinates;
  late int id;
  PostInfo({required this.coordinates, required this.id});
}

class CommentInfo {
  Coordinates coordinates;
  String filter;
  int id;
  int page;

  CommentInfo(
      {required this.coordinates, required this.filter, required this.page, required this.id});
}

class SubCommentInfo {
  Coordinates? coordinates;
  String? filter;
  int? replyId;
  int id;
  int page;

  SubCommentInfo(
      {this.coordinates, this.filter, required this.page, required this.id, this.replyId});
}

class CheckData {
  String? creator;
  String? createdAt;
  String? content;

  CheckData({this.content, this.createdAt, this.creator});

  bool checkData() {
    return [creator, createdAt, content].contains(null);
  }
}

class Feed {
  bool? success;
  String? message;
  Bagos? bagos;

  Feed({this.message, this.bagos, this.success});

  Feed.fromJson(Map<String, dynamic> json) {
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


class SinglePost {
  bool? success;
  String? message;
  Data? data;

  SinglePost({this.success, this.message, this.data});

  SinglePost.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = new Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['data'] = this.data!.toJson();
    return data;
  }
}

class Bagos {
  int? previousPage;
  late int currentPage;
  int? nextPage;
  late int total;
  late int limit;
  late List<Data> data;

  Bagos(
      {this.previousPage,
      required this.currentPage,
      this.nextPage,
      required this.total,
      required this.limit,
      required this.data});

  Bagos.fromJson(Map<String, dynamic> json) {
    previousPage = json['previousPage'];
    currentPage = json['currentPage'];
    nextPage = json['nextPage'];
    total = json['total'];
    limit = json['limit'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['previousPage'] = this.previousPage;
    data['currentPage'] = this.currentPage;
    data['nextPage'] = this.nextPage;
    data['total'] = this.total;
    data['limit'] = this.limit;

    data['data'] = this.data.map((v) => v.toJson()).toList();

    return data;
  }
}

class Data {
  bool? userVoted;
  int? userVote;
  bool? userIsNear;
  String? replyTo;
  Info? info;

  Data(
      {this.userVoted,
      this.userVote,
      this.userIsNear,
      this.replyTo,
      this.info});

  Data.fromJson(Map<String, dynamic> json) {
    userVoted = json['user_voted'];
    userVote = json['user_vote'];
    userIsNear = json['user_isNear'];
    replyTo = json['reply_to'];
    info = new Info.fromJson(json['info']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_voted'] = this.userVoted;
    data['user_vote'] = this.userVote;
    data['user_isNear'] = this.userIsNear;
    data['reply_to'] = this.replyTo;

    data['info'] = this.info!.toJson();

    return data;
  }
}

class Info {
  late int id;
  late String content;
  late Links links;
  late int votesTotal;
  late int commentsTotal;
  late int flags;
  late bool isFlagged;
  late String createdAt;
  late Creator creator;

  Info(
      {required this.id,
      required this.content,
      required this.links,
      required this.votesTotal,
      required this.commentsTotal,
      required this.flags,
      required this.isFlagged,
      required this.createdAt,
      required this.creator});

  Info.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    links = new Links.fromJson(json['links']);
    votesTotal = json['votes_total'];
    commentsTotal = json['comments_total'];
    flags = json['flags'];
    isFlagged = json['is_flagged'];
    createdAt = json['created_at'];
    creator = Creator.fromJson(json['creator']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['links'] = this.links.toJson();
    data['votes_total'] = this.votesTotal;
    data['comments_total'] = this.commentsTotal;
    data['flags'] = this.flags;
    data['is_flagged'] = this.isFlagged;
    data['created_at'] = this.createdAt;
    data['creator'] = this.creator.toJson();

    return data;
  }
}

class Links {
  String? url;
  String? title;
  String? description;
  String? image;
  String? video;
  String? site;

  Links(
      {this.url,
      this.title,
      this.description,
      this.image,
      this.video,
      this.site});

  bool checkUrl() {
    return [url, image].contains(null);
  }

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    video = json['video'];
    site = json['site'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['video'] = this.video;
    data['site'] = this.site;
    return data;
  }
}

class Creator {
  late int id;
  late String email;
  late String username;
  String? avatar;
  String? fcmToken;
  late bool active;

  Creator(
      {required this.id,
      required this.email,
      required this.username,
      this.avatar,
      this.fcmToken,
      required this.active});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    avatar = json['avatar'];
    fcmToken = json['fcm_token'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['fcm_token'] = this.fcmToken;
    data['active'] = this.active;
    return data;
  }
}
