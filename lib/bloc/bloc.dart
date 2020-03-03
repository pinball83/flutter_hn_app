import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hn_app/bloc/events.dart';
import 'package:flutter_hn_app/bloc/states.dart';
import 'package:flutter_hn_app/remote/news_store_remote.dart';
import 'package:flutter_hn_app/repository/news_repository.dart';

class HackerNewsBloc extends Bloc<NewsEvents, NewsState> {
  final HackerNewsRepository _repository = HackerNewsRepositoryImpl.instance;

  @override
  NewsState get initialState => NewsUninitialized();

  fetchNews() async {}

  @override
  Stream<NewsState> mapEventToState(NewsEvents event) async* {
    final currentState = state;
    if (event is FetchNews) {
      try {
        if (currentState is NewsUninitialized) {
          var news = await _repository.fetchNews();
          yield NewsLoaded(news: news, hasReachedMax: false);
          return;
        }
        if (currentState is NewsLoaded) {
          var news =
              await _repository.fetchNews(offset: currentState.news.length);
          yield news.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : NewsLoaded(
                  news: currentState.news + news, hasReachedMax: false);
        }
      } on NetworkErrorException catch (e) {
        yield ErrorState(message: e.message);
      }
    }
  }
}
