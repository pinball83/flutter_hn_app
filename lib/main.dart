import 'package:flutter/material.dart';
import 'package:flutter_hn_app/favorites/favorites_page.dart';
import 'package:flutter_hn_app/theme.dart';

import 'main/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ApplicationTheme.themeData,
      initialRoute: '/',
      routes: {
        MainPage.routName: (context) => MainPage(),
        FavoritesPage.routName: (context) => FavoritesPage(),
      },
    );
  }
}
