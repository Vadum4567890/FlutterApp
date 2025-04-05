// ignore_for_file: library_private_types_in_public_api, lines_longer_than_80_chars
// ignore_for_file: inference_failure_on_instance_creation
// This comment ignores the warning about using private types in public API.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/models/article.dart';
import 'package:my_project/screens/add_article_screen.dart';
import 'package:my_project/screens/article_detail_screen.dart';
import 'package:my_project/screens/edit_article_screen.dart';
import 'package:my_project/screens/new_list_screen.dart';
import 'package:my_project/services/auth_service.dart';

class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  List<Article> articles = [];

  void _addArticle(String title, String content, String? imagePath) async {
    final author = await AuthService.currentUser ?? 'Unknown User';

    setState(() {
      articles.add(Article(
        title: title,
        content: content,
        imagePath: imagePath,
        author: author,
      ),);
    });
  }

  void _editArticle(int index, String title, String content, String? imagePath) async {
    final author = await AuthService.currentUser ?? 'Unknown User';

    setState(() {
      articles[index] = Article(
        title: title,
        content: content,
        imagePath: imagePath,
        author: author,
      );
    });
  }


  void _deleteArticle(int index) {
    setState(() {
      articles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Articles'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: articles[index].imagePath != null
                      ? Image.file(
                          File(articles[index].imagePath!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image_not_supported),
                  title: Text('${articles[index].title} (by ${articles[index].author})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(index, articles[index]);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showDeleteDialog(index);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
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
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewListScreen()),
                );
              },
              child: Text('Go to New List'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
