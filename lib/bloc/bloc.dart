import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hn_app/bloc/events.dart';
import 'package:flutter_hn_app/bloc/states.dart';
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
          yield NewsLoaded(news: news);
          return;
        }
        if(currentState is NewsLoaded){
//          todo добавить пейджинг
//          final posts =
//          await _fetchPosts(currentState.posts.length, 20);
//          yield posts.isEmpty
//              ? currentState.copyWith(hasReachedMax: true)
//              : PostLoaded(
//            posts: currentState.posts + posts,
//            hasReachedMax: false,
//          );
        }
      } catch (e) {
        yield ErrorState();
      }
    }
  }
}
