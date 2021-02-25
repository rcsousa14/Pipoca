class UserAuth {
  String email;
  String password;
  String fcmToken;
  String avatar;
  String username;
  String type;

  UserAuth(
      {this.email,
      this.password,
      this.fcmToken,
      this.avatar,
      this.type,
      this.username});

  UserAuth.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fcmToken = json['fcm_token'];
    avatar = json['avatar'];
    username = json['username'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['fcm_token'] = this.fcmToken;
    data['avatar'] = this.avatar;
    data['type'] = this.type;
    data['username'] = this.username;

    return data;
  }
}
