import 'package:pipoca/src/models/user_feed_model.dart';

class Comentario {
  bool? success;
  String? message;
  Comments? comments;

  Comentario({this.success, this.message, this.comments});

  Comentario.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    comments = json['comments'] != null
        ? new Comments.fromJson(json['comments'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;

    data['comments'] = this.comments!.toJson();

    return data;
  }
}

class Comments {
  late int previousPage;
  late int currentPage;
  late int nextPage;
  late int total;
  late int limit;
  late List<Data> data;

  Comments(
      {required this.previousPage,
      required this.currentPage,
      required this.nextPage,
      required this.total,
      required this.limit,
      required this.data});

  Comments.fromJson(Map<String, dynamic> json) {
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
  late bool userVoted;
  late int userVote;
  late bool userIsNear;
  late Comment comment;

  Data(
      {required this.userVoted,
      required this.userVote,
      required this.userIsNear,
      required this.comment});

  Data.fromJson(Map<String, dynamic> json) {
    userVoted = json['user_voted'];
    userVote = json['user_vote'];
    userIsNear = json['user_isNear'];
    comment = Comment.fromJson(json['comment']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_voted'] = this.userVoted;
    data['user_vote'] = this.userVote;
    data['user_isNear'] = this.userIsNear;

    data['comment'] = this.comment.toJson();

    return data;
  }
}

class Comment {
  late int id;
  late String content;
  late Links links;
  late int votesTotal;
  late int subCommentsTotal;
  late int flags;
  late bool isFlagged;
  late bool isDeleted;
  late String createdAt;
  late Creator creator;

  Comment(
      {required this.id,
      required this.content,
      required this.links,
      required this.votesTotal,
      required this.subCommentsTotal,
      required this.flags,
      required this.isFlagged,
      required this.isDeleted,
      required this.createdAt,
      required this.creator});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    links = Links.fromJson(json['links']);
    votesTotal = json['votes_total'];
    subCommentsTotal = json['sub_comments_total'];
    flags = json['flags'];
    isFlagged = json['is_flagged'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    creator = Creator.fromJson(json['creator']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;

    data['links'] = this.links.toJson();

    data['votes_total'] = this.votesTotal;
    data['sub_comments_total'] = this.subCommentsTotal;
    data['flags'] = this.flags;
    data['is_flagged'] = this.isFlagged;
    data['is_deleted'] = this.isDeleted;
    data['created_at'] = this.createdAt;

    data['creator'] = this.creator.toJson();

    return data;
  }
}
