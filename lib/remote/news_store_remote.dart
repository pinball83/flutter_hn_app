import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/remote/rest_client.dart';

class HackerNewsStoreRemote {
  var restClient = HackerNewsRestClient();

  Future<List<int>> fetchIds() {
    return restClient.fetchIds().then((result) => List<int>.from(result.data));
  }

  Future<News> fetchNews(int itemId) async {
    return restClient
        .fetchNews(itemId)
        .then((result) => News.fromJson(result.data));

  }
}
