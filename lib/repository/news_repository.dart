import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/remote/news_store_remote.dart';

abstract class HackerNewsRepository {
  Future<List<News>> fetchNews({int offset});
}

class HackerNewsRepositoryImpl implements HackerNewsRepository {
  HackerNewsRepositoryImpl._constructor();

  static final HackerNewsRepository instance =
      HackerNewsRepositoryImpl._constructor();

  var remoteStore = HackerNewsStoreRemote();

  @override
  Future<List<News>> fetchNews({int offset = 0}) async {
    return await remoteStore
        .fetchIds(offset: offset)
        .then((value) => Future.wait(value
            .where((element) => element != null)
            .map((id) => remoteStore.fetchNews(id))))
        .catchError((onError) => News.error(onError));
  }
}
