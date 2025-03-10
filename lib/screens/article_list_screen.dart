// ignore_for_file: library_private_types_in_public_api
// This comment ignores the warning about using private types in public API.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/models/article.dart';
import 'package:my_project/screens/add_article_screen.dart';
import 'package:my_project/screens/article_detail_screen.dart';
import 'package:my_project/screens/edit_article_screen.dart';

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  List<Article> articles = [];

  // Method to add a new article
  void _addArticle(String title, String content, String? imagePath) {
    setState(() {
      articles.add(Article(title: title, content: content, imagePath: imagePath));
    });
  }

  // Method to delete an article
  void _deleteArticle(int index) {
    setState(() {
      articles.removeAt(index);
    });
  }

  // Method to edit an article
  void _editArticle(int index, String title, String content, String? imagePath) {
    setState(() {
      articles[index] = Article(title: title, content: content, imagePath: imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Articles')),
      body: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ListTile(
            // Displaying the article image, if available
            leading: articles[index].imagePath != null
                ? Image.file(
                    File(articles[index].imagePath!),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image_not_supported),
            title: Text(articles[index].title),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Button to edit the article
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(index, articles[index]);
                  },
                ),
                // Button to delete the article
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog(index);
                  },
                ),
              ],
            ),
            onTap: () {
              // Navigate to the article detail screen
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => ArticleDetailScreen(article: articles[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the add new article screen
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => AddArticleScreen(onAdd: _addArticle),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Method to display the article edit dialog
  void _showEditDialog(int index, Article article) {
    showDialog<void>(
      context: context,
      builder: (context) => EditArticleDialog(
        article: article,
        onEdit: (title, content, imagePath) {
          _editArticle(index, title, content, imagePath);
        },
      ),
    );
  }

  // Method to display the article delete dialog
  void _showDeleteDialog(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete article?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteArticle(index);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
