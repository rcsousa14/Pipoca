class CreatePost {
  String content;
  double latitude;
  double longitude;
  List<String> hashes;
  List<String> links;

  CreatePost(
      {this.content, this.latitude, this.longitude, this.hashes, this.links});

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