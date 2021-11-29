class Stories {
  String id;
  String url;
  String author;
  String authorImg;

  Stories({
    this.id,
    this.url,
    this.author,
    this.authorImg,
  });

  factory Stories.fromJson(Map<String, dynamic> data) {
    return Stories(
      id: data['_id'] as String,
      url: data['url'] as String,
      author: data['author'] as String,
      authorImg: data['authorImg'] as String,
    );
  }
}
