import 'package:pipoca/src/models/user_location_model.dart';

class FeedInfo {
  Coordinates? coordinates;
  String? filter;
  int page;

  FeedInfo({this.coordinates, this.filter, required this.page});
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
  Posts? posts;

  Feed({this.message, this.posts, this.success});

  Feed.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    posts = new Posts.fromJson(json['posts']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;

    data['posts'] = this.posts!.toJson();

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


class Posts {
  late int previousPage;
  late int currentPage;
  late int nextPage;
  late int total;
  late int limit;
  late List<Data> data;

  Posts(
      {required this.previousPage,
      required this.currentPage,
      required this.nextPage,
      required this.total,
      required this.limit,
      required this.data});

  Posts.fromJson(Map<String, dynamic> json) {
    previousPage = json['previousPage'];
    currentPage = json['currentPage'];
    nextPage = json['nextPage'];
    total = json['total'];
    limit = json['limit'];

    data = <Data>[];
    json['data'].forEach((v) {
      data.add(new Data.fromJson(v));
    });
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
  late bool userVoted;
  late int userVote;
  late bool userIsNear;
  late Post post;

  Data(
      {required this.userVoted,
      required this.userVote,
      required this.userIsNear,
      required this.post});

  Data.fromJson(Map<String, dynamic> json) {
    userVoted = json['user_voted'];
    userVote = json['user_vote'];
    userIsNear = json['user_isNear'];
    post = new Post.fromJson(json['post']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_voted'] = this.userVoted;
    data['user_vote'] = this.userVote;
    data['user_isNear'] = this.userIsNear;

    data['post'] = this.post.toJson();

    return data;
  }
}

class Post {
  late int id;
  late String content;
  late Links links;
  late int votesTotal;
  late int commentsTotal;
  late int flags;
  late bool isFlagged;
  late bool isDeleted;
  late String createdAt;
  late Creator creator;

  Post(
      {required this.id,
      required this.content,
      required this.links,
      required this.votesTotal,
      required this.commentsTotal,
      required this.flags,
      required this.isFlagged,
      required this.isDeleted,
      required this.createdAt,
      required this.creator});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    links = new Links.fromJson(json['links']);
    votesTotal = json['votes_total'];
    commentsTotal = json['comments_total'];
    flags = json['flags'];
    isFlagged = json['is_flagged'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    creator = new Creator.fromJson(json['creator']);
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
    data['is_deleted'] = this.isDeleted;
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
  late String avatar;
  String? fcmToken;

  late bool active;

  Creator(
      {required this.id,
      required this.email,
      required this.username,
      required this.avatar,
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
