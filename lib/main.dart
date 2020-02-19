import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/theme.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ApplicationTheme.themeData,
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
    var url =
        "https://hacker-news.firebaseio.com/v0/topstories.json?orderBy=\"\$key\"&limitToFirst=50&startAt=\"3\"";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Iterable jsonResponse = convert.jsonDecode(response.body);
      print("response: $jsonResponse");
      return Future.wait(jsonResponse
          .where((element) => element != null)
          .map((itemId) => _fetchNews(itemId)));
    } else {
      return Future.error(
          "Netowrk error code ${response.statusCode}, message: ${response.body}");
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
