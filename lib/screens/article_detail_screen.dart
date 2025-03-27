// ignore_for_file: prefer_const_constructors, lines_longer_than_80_chars
// This comment ignores the warning about preferring const constructors.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;
  const ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the article image if it exists, otherwise show a placeholder icon
            if (article.imagePath != null)
              Center(
                child: Image.file(
                  File(article.imagePath!),
                  height: 200,
                  fit: BoxFit.cover,
                ),
              )
            else
              Center(
                child: Icon(Icons.image_not_supported, size: 200),
              ),
            SizedBox(height: 20),
            // Display the article content
            Text(article.content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
