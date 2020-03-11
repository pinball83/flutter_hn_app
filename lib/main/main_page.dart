import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hn_app/favorites/favorites_page.dart';
import 'package:flutter_hn_app/main/bloc/events.dart';
import 'package:flutter_hn_app/main/bloc/states.dart';

import 'bloc/bloc.dart';
import 'model/news.dart';

class MainPage extends StatefulWidget {
  static const routName = '/';

  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hacker News Flutter Demo'), automaticallyImplyLeading: false, actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  FavoritesPage.routName,
                );
              },
              child: Icon(
                Icons.star_border,
                size: 26.0,
              ),
            )),
      ]),
      body: BlocProvider(
        create: (context) => HackerNewsBloc()..add(FetchNews()),
        child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: HackerNewsList()),
      ),
    );
  }
}

class HackerNewsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HackerNewsListState();
}

class HackerNewsListState extends State<HackerNewsList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  Completer _refreshCompleter;
  HackerNewsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _bloc = context.bloc<HackerNewsBloc>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _bloc.add(FetchNews());
    }
  }

  Future<void> _handleRefresh() {
    _bloc.add(ReloadNews());
    return _refreshCompleter?.future;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HackerNewsBloc, NewsState>(
        bloc: _bloc,
        builder: (context, state) {
          List<Widget> children;
          if (state is NewsUninitialized) {
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
          if (state is NewsLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
            return Container(
              color: Theme.of(context).accentColor,
              child: new RefreshIndicator(
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: state.hasReachedMax ? state.news.length : state.news.length + 1,
                      itemBuilder: (context, i) {
                        return i >= state.news.length ? BottomLoader() : _buildRow(i, state.news[i]);
                      }),
                  onRefresh: _handleRefresh),
            );
          }
          if (state is ErrorState) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${state.message}', style: Theme.of(context).textTheme.display1),
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
              ),
            ),
          );
        });
  }

  Widget _buildRow(int index, News news) {
    return ListTile(
      title: Text("$index ${news.title}", style: Theme.of(context).textTheme.display2),
      onTap: () {
        log('tap ${news.url}');
      },
      trailing: new IconButton(
        icon: new Icon(Icons.star_border,color: Theme.of(context).accentIconTheme.color,),
        onPressed: () {
          log("icon tap");
        },
      ),
    );
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}
