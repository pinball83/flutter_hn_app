import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/remote/rest_client.dart';

class HackerNewsStoreRemote {
  static const int _perPage = 10;

  var restClient = HackerNewsRestClient();

  Future<List<int>> fetchIds({int offset, int perPage = _perPage}) {
    return restClient
        .fetchIds(offset, perPage)
        .then((result) => List<int>.from(result.data));
  }

  Future<News> fetchNews(int itemId) async {
    return restClient
        .fetchNews(itemId)
        .then((result) => News.fromJson(result.data));
  }
}
