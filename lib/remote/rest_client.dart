import 'package:dio/dio.dart';

class HackerNewsRestClient {
  Dio _dio;

  HackerNewsRestClient() {
    _dio = Dio(BaseOptions(baseUrl: "https://hacker-news.firebaseio.com/v0/"));
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> fetchIds(int offset, int perPage) {
    return _dio.get("topstories.json", queryParameters: {
      "orderBy": "\"\$key\"",
      "limitToFirst": perPage,
      "startAt": "\"$offset\""
    });
  }

  Future<Response> fetchNews(int itemId) {
    return _dio.get("item/$itemId.json");
  }
}
