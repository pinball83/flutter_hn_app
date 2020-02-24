import 'dart:async';

import 'package:flutter_hn_app/bloc/actions.dart';
import 'package:flutter_hn_app/bloc/states.dart';
import 'package:flutter_hn_app/repository/news_repository.dart';

class HackerNewsBloc{
  final HackerNewsRepository _repository = HackerNewsRepositoryImpl.instance;


  NewsState _state = NewsLoadedState();
  NewsState get state => _state;
  set state(state) {
    this._state = state;
    blocStream.eventOut = state;
  }

  NewsState _scrollState = NewsScrolledState();
  NewsState get scrollState => _scrollState;

  set scrollState(state) {
    this._scrollState = state;
    scrollStream.eventOut = state;
  }

  BlocStream<NewsState> blocStream = BlocStream();

  BlocStream<NewsState> scrollStream = BlocStream();

  HackerNewsBloc() {
    mapEventToState(ScrollNews());
  }

  Future<void> mapEventToState(NewsActions event) async {

    if (event is ScrollNews) {
      if (scrollState.isLoading) return;
      _scrollState = scrollState.copy(true);
    } else {
      state = state.copy(true);
    }

    if (event is LoadNews) {
      state = NewsLoadedState();
    } else if (event is ScrollNews) {
      await _repository.fetchNews();
      scrollState = NewsScrolledState();
    }
  }

  void dispose(){
  }
}

class BlocStream<T> {

  final StreamController<T> _streamController = StreamController.broadcast();

  Stream<T> get stream => _streamController.stream;

  set eventOut(T data) {
    _streamController.add(data);
  }
}