class News {
  final String title;
  final String url;
  final String error;

  News(this.title, this.url, this.error);

  News.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        url = json["url"],
        error = "";

  News.error(String error)
      : title = "",
        url = "",
        this.error = error;
}
