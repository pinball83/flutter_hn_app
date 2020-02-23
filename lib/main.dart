import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hn_app/model/news.dart';
import 'package:flutter_hn_app/theme.dart';

import 'repository/news_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: HackerNewsList()),
    );
  }
}

class HackerNewsList extends StatefulWidget {

  HackerNewsList();

  @override
  State<StatefulWidget> createState() => HackerNewsListState();
}

class HackerNewsListState extends State<HackerNewsList> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
        future: futureNews,
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

  HackerNewsRepository repository = HackerNewsRepositoryImpl();

  Future<List<News>> futureNews;
  @override
  void initState() {
    super.initState();
    futureNews = repository.fetchNews();
  }
}
