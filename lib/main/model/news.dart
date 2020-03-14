import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String url;
  final bool isAdded;

  const News({this.title, this.url, this.isAdded});

  News.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        url = json["url"],
        isAdded = false;

  News copyWith({String title, String url, bool isAdded}) {
    return News(title: title ?? this.title, url: url ?? this.url, isAdded: isAdded ?? this.isAdded);
  }

  @override
  List<Object> get props => [this.title, this.url, this.isAdded];
}
