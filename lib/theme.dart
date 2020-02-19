import 'package:flutter/material.dart';

class ApplicationTheme {
   static final themeData = ThemeData(
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
            fontSize: 18.0, fontStyle: FontStyle.normal, color: Colors.black45),
        display2: TextStyle(
            fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black45),
      ));
}
