class CreatePost {
  String? content;
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
  int? postId;
  int? voted;

  PostPoint({this.postId, this.voted});

  PostPoint.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    voted = json['voted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['voted'] = this.voted;
    return data;
  }
}
