import 'package:flutter_hn_app/main/model/news.dart';
import 'package:flutter_hn_app/main/remote/news_store_remote.dart';

abstract class HackerNewsRepository {
  Future<List<News>> fetchNews({int offset});

  Future<News> addToFavorites(News news);
}

class HackerNewsRepositoryImpl implements HackerNewsRepository {
  HackerNewsRepositoryImpl._constructor();

  static final HackerNewsRepository instance = HackerNewsRepositoryImpl._constructor();

  var remoteStore = HackerNewsStoreRemote();

  @override
  Future<List<News>> fetchNews({int offset = 0}) async {
    return await remoteStore.fetchIds(offset: offset).then((value) => Future.wait(value.where((element) => element != null).map((id) => remoteStore.fetchNews(id))));
  }

  @override
  Future<News> addToFavorites(News news) {
    return Future.value(news.copyWith(isAdded: !news.isAdded));
  }
}
