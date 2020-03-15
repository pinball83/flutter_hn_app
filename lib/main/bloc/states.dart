import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hn_app/main/model/news.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsUninitialized extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> news;
  final bool hasReachedMax;

  const NewsLoaded({this.news, this.hasReachedMax});

  NewsLoaded copyWith({List<News> news, bool hasReachedMax}) {
    return NewsLoaded(
        news: news ?? this.news,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  List<Object> get props => [news, hasReachedMax];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is NewsLoaded &&
              runtimeType == other.runtimeType &&
              listEquals(news, other.news) &&
              hasReachedMax == other.hasReachedMax;

  @override
  int get hashCode =>
      super.hashCode ^
      hashList(news) ^
      hasReachedMax.hashCode;

  @override
  String toString() =>
      'NewsLoaded { posts: ${news.length}, hasReachedMax: $hasReachedMax }';
}

class ErrorState extends NewsState {
  final String message;

  const ErrorState({this.message});
}
