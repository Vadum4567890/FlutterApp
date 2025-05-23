import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:my_project/cubit/article_list/article_state.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/models/article.dart';
import 'package:my_project/screens/add_article_screen.dart';
import 'package:my_project/screens/article_detail_screen.dart';
import 'package:my_project/screens/edit_article_screen.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleCubit>().loadArticles();
    });

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
            onPressed: () {
              context.read<AuthCubit>().logout();
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
          child: BlocConsumer<ArticleCubit, ArticleState>(
            listener: (context, state) {
              if (state is ArticleError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
              if (state is ArticleLoaded) {
                // No specific action needed, just rebuilds
              }
            },
            builder: (context, state) {
              if (state is ArticleLoading || state is ArticleInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ArticleLoaded) {
                if (state.articles.isEmpty) {
                  return const Center(
                    child: Text(
                      'No articles yet. Add some!',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) {
                    final article = state.articles[index];
                    return Card(
                      color: Colors.white.withOpacity(0.2),
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FutureBuilder<bool>(
                        future: context
                            .read<ArticleCubit>()
                            .canEditOrDelete(article),
                        builder: (context, snapshot) {
                          final canModify = snapshot.data ?? false;
                          return ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: article.imagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(article.imagePath!),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported,
                                    color: Colors.white),
                            title: Text(
                              article.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'by ${article.author}',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.7)),
                            ),
                            trailing: canModify
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.white),
                                        onPressed: () {
                                          _showEditDialog(context, article);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.white),
                                        onPressed: () {
                                          _showDeleteDialog(
                                              context, article.id!);
                                        },
                                      ),
                                    ],
                                  )
                                : null, // No trailing widget if cannot modify
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(
                                    article: article,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              } else if (state is ArticleError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                );
              }
              return const SizedBox.shrink(); // Fallback
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddArticleScreen(
                onAdd: (title, content, imagePath) {
                  context
                      .read<ArticleCubit>()
                      .addArticle(title, content, imagePath);
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showEditDialog(BuildContext context, Article article) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => EditArticleDialog(
        article: article,
        onEdit: (title, content, imagePath) {
          final updatedArticle = Article(
            id: article.id,
            title: title,
            content: content,
            imagePath: imagePath,
            author: article.author, // Author remains the same
          );
          context.read<ArticleCubit>().updateArticle(updatedArticle);
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int articleId) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete article?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ArticleCubit>().deleteArticle(articleId);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
