import 'package:dio/dio.dart';

class HackerNewsRestClient {
  Dio _dio;

  HackerNewsRestClient() {
    _dio = Dio(BaseOptions(baseUrl: "https://hacker-news.firebaseio.com/v0/"));
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> fetchIds() {
    return _dio.get("topstories.json", queryParameters: {
        "orderBy": "\"\$key\"",
        "limitToFirst": 50,
        "startAt": "\"3\""
      });
//    try {
//      var response = await _dio.get("topstories.json", queryParameters: {
//        "orderBy": "\"\$key\"",
//        "limitToFirst": 50,
//        "startAt": "\"3\""
//      });
//      return response.data;
//    } catch (error, stacktrace) {
//      print("Exception occured: $error stackTrace: $stacktrace");
//      return List();
//    }
//    if (response.statusCode == 200) {
//      Iterable jsonResponse = convert.jsonDecode(response.body);
//      print("response: $jsonResponse");
//      return Future.wait(jsonResponse
//          .where((element) => element != null)
//          .map((itemId) => _fetchNews(itemId)));
//    } else {
//      return Future.error(
//          "Netowrk error code ${response.statusCode}, message: ${response.body}");
//    }
  }

  Future<Response> fetchNews(int itemId) {
//    try {
      return _dio.get("item/$itemId.json");
//      return News.fromJson(response.data);
//    } catch (error, stacktrace) {
//      print("Exception occured: $error stackTrace: $stacktrace");
//      return News.error(error);
    }
//    var url = "https://hacker-news.firebaseio.com/v0/item/$itemId.json";
//    var response = await http.get(url);
//    if (response.statusCode == 200) {
//      var jsonDecode = convert.jsonDecode(response.body);
//      return News.fromJson(jsonDecode);
//    }
//  }
}
