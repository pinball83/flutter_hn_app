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

  const NewsLoaded({this.news});

  NewsLoaded copyWith({List<News> news}) {
    return NewsLoaded(news: news ?? this.news);
  }
}

class ErrorState extends NewsState {
}
