class LinkInfo {
  String message;
  Data data;

  LinkInfo({this.message, this.data});

  LinkInfo.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String url;
  String title;
  String siteName;
  String description;
  String mediaType;
  String contentType;
  List<String> images;
  List<Videos> videos;
  List<String> favicons;

  Data(
      {this.url,
      this.title,
      this.siteName,
      this.description,
      this.mediaType,
      this.contentType,
      this.images,
      this.videos,
      this.favicons});

  Data.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    siteName = json['siteName'];
    description = json['description'];
    mediaType = json['mediaType'];
    contentType = json['contentType'];
    images = json['images'].cast<String>();
    if (json['videos'] != null) {
      videos = new List<Videos>();
      json['videos'].forEach((v) {
        videos.add(new Videos.fromJson(v));
      });
    }
    favicons = json['favicons'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['siteName'] = this.siteName;
    data['description'] = this.description;
    data['mediaType'] = this.mediaType;
    data['contentType'] = this.contentType;
    data['images'] = this.images;
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    data['favicons'] = this.favicons;
    return data;
  }
}

class Videos {
  String url;
  String secureUrl;
  String type;
  String width;
  String height;

  Videos({this.url, this.secureUrl, this.type, this.width, this.height});

  Videos.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    secureUrl = json['secureUrl'];
    type = json['type'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['secureUrl'] = this.secureUrl;
    data['type'] = this.type;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}