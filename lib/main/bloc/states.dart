import 'package:flutter_hn_app/main/model/news.dart';

abstract class NewsState {
  const NewsState();
}

class NewsUninitialized extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> news;
  final bool hasReachedMax;

  const NewsLoaded({this.news, this.hasReachedMax});

  NewsLoaded copyWith({List<News> news, bool hasReachedMax}) {
    return NewsLoaded(news: news ?? this.news, hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || super == other && other is NewsLoaded && runtimeType == other.runtimeType && news == other.news && hasReachedMax == other.hasReachedMax;

  @override
  int get hashCode => super.hashCode ^ news.hashCode ^ hasReachedMax.hashCode;

  @override
  String toString() => 'NewsLoaded { posts: ${news.length}, hasReachedMax: $hasReachedMax }';
}

class ErrorState extends NewsState {
  final String message;

  const ErrorState({this.message});
}
