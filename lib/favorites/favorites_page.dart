import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hn_app/main/main_page.dart';

class FavoritesPage extends StatelessWidget {
  static const routName = '/fav';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MainPage.routName);
          },
        ),
      ),
      body: Container(
        child: Text("Здесь будут выбранные новости"),
      ),
    );
  }
}
