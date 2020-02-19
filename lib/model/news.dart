class News {
  final String title;
  final String url;

  News(this.title, this.url);

  News.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        url = json["url"];
}