class UserAuth {
  String username;
  String phoneNumber;
  String fcmToken;

  UserAuth({this.username, this.phoneNumber, this.fcmToken});

  UserAuth.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneNumber = json['phone_number'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone_number'] = this.phoneNumber;
    data['fcm_token'] = this.fcmToken;
    return data;
  }
}