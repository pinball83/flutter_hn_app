import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hn_app/main/bloc/events.dart';
import 'package:flutter_hn_app/main/bloc/states.dart';
import 'package:flutter_hn_app/main/remote/news_store_remote.dart';
import 'package:flutter_hn_app/main/repository/news_repository.dart';

class HackerNewsBloc extends Bloc<NewsEvents, NewsState> {
  final HackerNewsRepository _repository = HackerNewsRepositoryImpl.instance;

  @override
  NewsState get initialState => NewsUninitialized();

  @override
  Stream<NewsState> mapEventToState(NewsEvents event) async* {
    final currentState = state;
    if (event is FetchNews && !_hasReachedMax(currentState)) {
      try {
        if (currentState is NewsUninitialized) {
          var news = await _repository.fetchNews();
          yield NewsLoaded(news: news, hasReachedMax: false);
          return;
        }
        if (currentState is NewsLoaded) {
          var news = await _repository.fetchNews(offset: currentState.news.length);
          yield news.isEmpty ? currentState.copyWith(hasReachedMax: true) : NewsLoaded(news: currentState.news + news, hasReachedMax: false);
        }
      } on NetworkErrorException catch (e) {
        yield ErrorState(message: e.message);
      }
    } else if (event is ReloadNews) {
      var news = await _repository.fetchNews();
      yield NewsLoaded(news: news, hasReachedMax: false);
      return;
    }
  }

  bool _hasReachedMax(NewsState state) => state is NewsLoaded && state.hasReachedMax;
}