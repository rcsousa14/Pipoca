class Youtube {
  int thumbnailWidth;
  String thumbnailUrl;
  String authorName;
  String type;
  String authorUrl;
  String providerUrl;
  int width;
  String url;
  String providerName;
  String title;
  String html;
  int height;
  String version;
  int thumbnailHeight;

  Youtube(
      {this.thumbnailWidth,
      this.thumbnailUrl,
      this.authorName,
      this.type,
      this.authorUrl,
      this.providerUrl,
      this.width,
      this.url,
      this.providerName,
      this.title,
      this.html,
      this.height,
      this.version,
      this.thumbnailHeight});

  Youtube.fromJson(Map<String, dynamic> json) {
    thumbnailWidth = json['thumbnail_width'];
    thumbnailUrl = json['thumbnail_url'];
    authorName = json['author_name'];
    type = json['type'];
    authorUrl = json['author_url'];
    providerUrl = json['provider_url'];
    width = json['width'];
    url = json['url'];
    providerName = json['provider_name'];
    title = json['title'];
    html = json['html'];
    height = json['height'];
    version = json['version'];
    thumbnailHeight = json['thumbnail_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thumbnail_width'] = this.thumbnailWidth;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['author_name'] = this.authorName;
    data['type'] = this.type;
    data['author_url'] = this.authorUrl;
    data['provider_url'] = this.providerUrl;
    data['width'] = this.width;
    data['url'] = this.url;
    data['provider_name'] = this.providerName;
    data['title'] = this.title;
    data['html'] = this.html;
    data['height'] = this.height;
    data['version'] = this.version;
    data['thumbnail_height'] = this.thumbnailHeight;
    return data;
  }
}