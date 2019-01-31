import 'package:flutter/material.dart';
import 'package:giphy_app/ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        hintColor: Colors.white
      ),
    );
  }
}


