// ignore_for_file: inference_failure_on_instance_creation, use_build_context_synchronously, unnecessary_null_comparison, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/core/interfaces/article_service_interface.dart';
import 'package:my_project/domain/services/auth_service.dart';
import 'package:my_project/models/article.dart';
import 'package:my_project/screens/add_article_screen.dart';
import 'package:my_project/screens/article_detail_screen.dart';
import 'package:my_project/screens/edit_article_screen.dart';

class ArticleListScreen extends StatefulWidget {
  final AuthService authService;
  final ArticleServiceInterface articleService;

  const ArticleListScreen({
    required this.authService,
    required this.articleService,
    super.key,
  });

  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() async {
    final loadedArticles = await widget.articleService.getArticles();
    setState(() {
      articles = loadedArticles;
    });
  }

  Future<bool> _canEditOrDelete(Article article) async {
    final currentUser = await widget.authService.getCurrentUser();
    return currentUser == article.author;
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

  void _editArticle(int index, String title, String content, String? imagePath) async {
    final author = (await widget.authService.getCurrentUser()) ?? 'Unknown User';
    final updatedArticle = Article(
      id: articles[index].id,
      title: title,
      content: content,
      imagePath: imagePath,
      author: author,
    );
    await widget.articleService.updateArticle(updatedArticle);
    _loadArticles();
  }

  void _showDeleteDialog(int index) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete article?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteArticle(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteArticle(int index) async {
    final articleId = articles[index].id;
    if (articleId != null) {
      await widget.articleService.deleteArticle(articleId);
      _loadArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Articles', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await widget.authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withOpacity(0.2),
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: articles[index].imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(articles[index].imagePath!),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(Icons.image_not_supported, color: Colors.white),
                        title: Text(
                          articles[index].title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'by ${articles[index].author}',
                          style: TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                        trailing: FutureBuilder<bool>(
                          future: _canEditOrDelete(articles[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.data == true) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    onPressed: () => _showEditDialog(index, articles[index]),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.white),
                                    onPressed: () => _showDeleteDialog(index),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(
                                article: articles[index],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddArticleScreen(onAdd: _addArticle),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addArticle(String title, String content, String? imagePath) async {
    final author = (await widget.authService.getCurrentUser()) ?? 'Unknown User';
    final newArticle = Article(
      title: title,
      content: content,
      imagePath: imagePath,
      author: author,
    );
    await widget.articleService.addArticle(newArticle);
    _loadArticles();
  }
}
