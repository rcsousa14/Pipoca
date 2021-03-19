class Usuario {
  String message;
  User user;

  Usuario({this.message, this.user});

  Usuario.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String username;
  String email;
  String bio;
  String avatar;
  String birthday;
  String fcmToken;
  String createdAt;
  int karmaTotal;
  int interationTotal;
  Karma karma;
  Interation interation;

  User(
      {this.id,
      this.username,
      this.email,
      this.bio,
      this.avatar,
      this.birthday,
      this.fcmToken,
      this.createdAt,
      this.karmaTotal,
      this.interationTotal,
      this.karma,
      this.interation});

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
    karma = json['karma'] != null ? new Karma.fromJson(json['karma']) : null;
    interation = json['interation'] != null
        ? new Interation.fromJson(json['interation'])
        : null;
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
    if (this.karma != null) {
      data['karma'] = this.karma.toJson();
    }
    if (this.interation != null) {
      data['interation'] = this.interation.toJson();
    }
    return data;
  }
}

class Karma {
  int postsVotesTotal;
  int commentsVotesTotal;
  int subCommentsVotesTotal;

  Karma(
      {this.postsVotesTotal,
      this.commentsVotesTotal,
      this.subCommentsVotesTotal});

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
  int userPostsTotal;
  int userCommentsTotal;
  int userSubCommentsTotal;

  Interation(
      {this.userPostsTotal, this.userCommentsTotal, this.userSubCommentsTotal});

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