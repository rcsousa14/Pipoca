import 'package:pipoca/src/models/user_location_model.dart';

class FeedInfo {
  Coordinates coordinates; 
  String filter; 
  int page;

  FeedInfo({this.coordinates, this.filter, this.page});
}

class Feed {
  String message;
  Posts posts;

  Feed({this.message, this.posts});

  Feed.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    posts = json['posts'] != null ? new Posts.fromJson(json['posts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.posts != null) {
      data['posts'] = this.posts.toJson();
    }
    return data;
  }
}

class Posts {
  int previousPage;
  int currentPage;
  int nextPage;
  int total;
  int limit;
  List<Data> data;

  Posts(
      {this.previousPage,
      this.currentPage,
      this.nextPage,
      this.total,
      this.limit,
      this.data});

  Posts.fromJson(Map<String, dynamic> json) {
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
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  bool userVoted;
  int userVote;
  bool userIsNear;
  Post post;

  Data({this.userVoted, this.userVote, this.userIsNear, this.post});

  Data.fromJson(Map<String, dynamic> json) {
    userVoted = json['user_voted'];
    userVote = json['user_vote'];
    userIsNear = json['user_isNear'];
    post = json['post'] != null ? new Post.fromJson(json['post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_voted'] = this.userVoted;
    data['user_vote'] = this.userVote;
    data['user_isNear'] = this.userIsNear;
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    return data;
  }
}

class Post {
  int id;
  String content;
  int votesTotal;
  int commentsTotal;
  int flags;
  bool isFlagged;
  bool isDeleted;
  String createdAt;
  Creator creator;

  Post(
      {this.id,
      this.content,
      this.votesTotal,
      this.commentsTotal,
      this.flags,
      this.isFlagged,
      this.isDeleted,
      this.createdAt,
      this.creator});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    votesTotal = json['votes_total'];
    commentsTotal = json['comments_total'];
    flags = json['flags'];
    isFlagged = json['is_flagged'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['votes_total'] = this.votesTotal;
    data['comments_total'] = this.commentsTotal;
    data['flags'] = this.flags;
    data['is_flagged'] = this.isFlagged;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    return data;
  }
}

class Creator {
  int id;
  String email;
  String username;
  String avatar;
  String fcmToken;
  String type;
  bool active;

  Creator(
      {this.id,
      this.email,
      this.username,
      this.avatar,
      this.fcmToken,
      this.type,
      this.active});

  Creator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    avatar = json['avatar'];
    fcmToken = json['fcm_token'];
    type = json['type'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['avatar'] = this.avatar;
    data['fcm_token'] = this.fcmToken;
    data['type'] = this.type;
    data['active'] = this.active;
    return data;
  }
}