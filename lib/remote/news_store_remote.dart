import 'package:dio/dio.dart';
import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/remote/rest_client.dart';

class HackerNewsStoreRemote {
  static const int _perPage = 20;

  var restClient = HackerNewsRestClient();

  Future<List<int>> fetchIds({int offset, int perPage = _perPage}) {
    return restClient
        .fetchIds(offset, perPage)
        .then((result) => List<int>.from(result.data))
        .catchError(rethrowNetworkError, test: (e) => e is DioError);
  }

  Future<News> fetchNews(int itemId) async {
    return restClient
        .fetchNews(itemId)
        .then((result) => News.fromJson(result.data))
        .catchError(rethrowNetworkError, test: (e) => e is DioError);
  }

  rethrowNetworkError(onError) {
    var networkError = (onError as DioError).response;
    throw NetworkErrorException(
        "Exception occured: ${networkError.statusCode} stackTrace: ${networkError.statusMessage}");
  }
}

class NetworkErrorException implements Exception {
  final String message;

  NetworkErrorException(this.message);
}
