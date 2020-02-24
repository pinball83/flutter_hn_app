import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/remote/news_store_remote.dart';

abstract class HackerNewsRepository {
  Future<List<News>> fetchNews();
}

class HackerNewsRepositoryImpl implements HackerNewsRepository {
  HackerNewsRepositoryImpl._construtctor();

  static final HackerNewsRepository instance =
      HackerNewsRepositoryImpl._construtctor();

  var remoteStore = HackerNewsStoreRemote();

  @override
  Future<List<News>> fetchNews() async {
    return await remoteStore
        .fetchIds()
        .then((value) => Future.wait(value
            .where((element) => element != null)
            .map((id) => remoteStore.fetchNews(id))))
        .catchError((onError) => News.error(onError));
  }
}
