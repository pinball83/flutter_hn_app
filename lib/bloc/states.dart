import 'package:equatable/equatable.dart';
import 'package:flutter_hn_app/model/news.dart';

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
}

class ErrorState extends NewsState {
  final String message;

  const ErrorState({this.message});
}
