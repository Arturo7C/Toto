import 'package:flutter/material.dart';
import 'package:toto/services/authentication.dart';
import 'package:toto/pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Toto',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
