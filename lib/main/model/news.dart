class News {
  final String title;
  final String url;
  final bool isAdded;

  News.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        url = json["url"],
        isAdded = false;

}