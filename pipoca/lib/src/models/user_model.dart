class Usuario {
  late bool success;
  late String message;
  late User? user;

  Usuario({required this.success, required this.message, this.user});

  Usuario.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['user'] = this.user!.toJson();

    return data;
  }
}

class User {
  late int id;
  late String username;
  late String email;
  String? bio;
  String? avatar;
  String? birthday;
  String? fcmToken;
  late String createdAt;
  late int karmaTotal;
  late int interationTotal;
  late Karma karma;
  late Interation interation;

  User(
      {required this.id,
      required this.username,
      required this.email,
      this.bio,
      this.avatar,
      this.birthday,
      this.fcmToken,
      required this.createdAt,
      required this.karmaTotal,
      required this.interationTotal,
      required this.karma,
      required this.interation});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    avatar = json['avatar'];
    birthday = json['birthday'];
    fcmToken = json['fcm_token'];
    createdAt = json['created_at'];
    karmaTotal = json['karma_total'];
    interationTotal = json['interation_total'];
    karma = new Karma.fromJson(json['karma']);
    interation = new Interation.fromJson(json['interation']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['bio'] = this.bio;
    data['avatar'] = this.avatar;
    data['birthday'] = this.birthday;
    data['fcm_token'] = this.fcmToken;
    data['created_at'] = this.createdAt;
    data['karma_total'] = this.karmaTotal;
    data['interation_total'] = this.interationTotal;

    data['karma'] = this.karma.toJson();

    data['interation'] = this.interation.toJson();

    return data;
  }
}

class Karma {
  late int postsVotesTotal;
  late int commentsVotesTotal;
  late int subCommentsVotesTotal;

  Karma(
      {required this.postsVotesTotal,
      required this.commentsVotesTotal,
      required this.subCommentsVotesTotal});

  Karma.fromJson(Map<String, dynamic> json) {
    postsVotesTotal = json['posts_votes_total'];
    commentsVotesTotal = json['comments_votes_total'];
    subCommentsVotesTotal = json['sub_comments_votes_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['posts_votes_total'] = this.postsVotesTotal;
    data['comments_votes_total'] = this.commentsVotesTotal;
    data['sub_comments_votes_total'] = this.subCommentsVotesTotal;
    return data;
  }
}

class Interation {
  late int userPostsTotal;
  late int userCommentsTotal;
  late int userSubCommentsTotal;

  Interation(
      {required this.userPostsTotal,
      required this.userCommentsTotal,
      required this.userSubCommentsTotal});

  Interation.fromJson(Map<String, dynamic> json) {
    userPostsTotal = json['user_posts_total'];
    userCommentsTotal = json['user_comments_total'];
    userSubCommentsTotal = json['user_sub_comments_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_posts_total'] = this.userPostsTotal;
    data['user_comments_total'] = this.userCommentsTotal;
    data['user_sub_comments_total'] = this.userSubCommentsTotal;
    return data;
  }
}
