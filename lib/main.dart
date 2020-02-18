import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.dark,
          primaryColor: Color.fromRGBO(253, 103, 33, 1.0),
          accentColor: Color.fromRGBO(246, 246, 240, 1.0),
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic,
            ),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            display1: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.normal,
                color: Colors.black45),
            display2: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          )),
      home: MainPage(title: 'Hacker News Flutter Demo'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<News> _news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: HackerNewsList(_news)),
    );
  }
}

class HackerNewsList extends StatefulWidget {
  final List<News> news;

  HackerNewsList(this.news);

  @override
  State<StatefulWidget> createState() => HackerNewsListState(news);
}

class HackerNewsListState extends State<HackerNewsList> {
  List<News> news;

  HackerNewsListState(this.news);

  //todo перенести в отдельный рест клиент
  Future<List<News>> _fetchId() async {
    var url = "https://hacker-news.firebaseio.com/v0/topstories.json";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable jsonResponse = convert.jsonDecode(response.body);
      print("response: $jsonResponse");
      return Future.wait(jsonResponse.map((itemId) => _fetchNews(itemId)));
    }
  }

//todo перенести в отдельный рест клиент
  Future<News> _fetchNews(int itemId) async {
    var url = "https://hacker-news.firebaseio.com/v0/item/$itemId.json";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonDecode = convert.jsonDecode(response.body);
      return News.fromJson(jsonDecode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
        future: _fetchId(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            return Container(
                color: Theme.of(context).accentColor,
                child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return _buildRow(snapshot.data[i]);
                    }));
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.display1),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Awaiting result...',
                  style: Theme.of(context).textTheme.display1,
                ),
              )
            ];
          }
          return Container(
            color: Theme.of(context).accentColor,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            )),
          );
        });
  }

  Widget _buildRow(News news) {
    return ListTile(
      title: Text(news.title, style: Theme.of(context).textTheme.display2),
      onTap: () {
        log('tap ${news.url}');
      },
    );
  }
}

//todo вынести в отдельный класс
class News {
  final String title;
  final String url;

  News(this.title, this.url);

  News.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        url = json["url"];
}
