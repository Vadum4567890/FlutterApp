import 'package:flutter/material.dart';
import 'package:my_project/screens/article_list_screen.dart';

void main() {
  runApp(ArticleApp());
}

class ArticleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Articles App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ArticleListScreen(),
    );
  }
}
