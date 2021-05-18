class CreateSubComment {
  late int replyToId;
  late String content;
  double? latitude;
  double? longitude;
  List<String>? hashes;
  List<String>? links;

  CreateSubComment(
      {required this.replyToId,
      required this.content,
      this.latitude,
      this.longitude,
      this.links,
      this.hashes});

  CreateSubComment.fromJson(Map<String, dynamic> json) {
    replyToId = json['reply_to_id'];
    content = json['content'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    links = json['links'].cast<String>();
    hashes = json['hashes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reply_to_id'] = this.replyToId;
    data['content'] = this.content;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['links'] = this.links;
    data['hashes'] = this.hashes;
    return data;
  }
}

class CreatePost {
  late String content;
  double? latitude;
  double? longitude;
  List<String>? hashes;
  List<String>? links;

  CreatePost(
      {required this.content,
      this.latitude,
      this.longitude,
      this.hashes,
      this.links});

  bool checkContent() {
    return [content, latitude, longitude].contains(null);
  }

  CreatePost.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    hashes = json['hashes'].cast<String>();
    links = json['links'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['hashes'] = this.hashes;
    data['links'] = this.links;
    return data;
  }
}

class PostPoint {
  int? id;
  int? voted;

  PostPoint({this.id, this.voted});

  PostPoint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voted = json['voted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voted'] = this.voted;
    return data;
  }
}
