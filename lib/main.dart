import 'package:flutter/material.dart';
import 'utils/const.dart';
import 'views/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: Constants.lighTheme(context),
      home: HomePage(),
    );
  }
}
