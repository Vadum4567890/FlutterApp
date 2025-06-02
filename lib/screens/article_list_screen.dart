// ignore_for_file: inference_failure_on_instance_creation

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:my_project/cubit/article_list/article_state.dart';
import 'package:my_project/models/article.dart';
import 'package:my_project/screens/add_article_screen.dart';
import 'package:my_project/screens/article_detail_screen.dart';
import 'package:my_project/screens/edit_article_screen.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({super.key});

  static const LinearGradient _backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF283593),
      Color(0xFF673AB7),
      Color(0xFF880E4F),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.5, 0.9],
  );

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
        title: Text(
          'Articles',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/qr_scanner'),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: _backgroundGradient,
            ),
          ),
          SafeArea(
            child: BlocConsumer<ArticleCubit, ArticleState>(
              listener: (context, state) {
                if (state is ArticleError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is ArticleLoading || state is ArticleInitial) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.white),);
                } else if (state is ArticleLoaded) {
                  if (state.articles.isEmpty) {
                    return Center(
                      child: Text(
                        'No articles yet. Add some!',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 18,),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final article = state.articles[index];
                      return _buildArticleListItem(context, article);
                    },
                  );
                } else if (state is ArticleError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: GoogleFonts.poppins(
                          color: Colors.red, fontSize: 18,),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
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
        child: Icon(Icons.add, color: _backgroundGradient.colors.first),
      ),
    );
  }

  Widget _buildArticleListItem(BuildContext context, Article article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FutureBuilder<bool>(
        future: context.read<ArticleCubit>().canEditOrDelete(article),
        builder: (context, snapshot) {
          final canModify = snapshot.data ?? false;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: 50,
              height: 50,
              child: article.imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(article.imagePath!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              color: Colors.red,);
                        },
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      color: Colors.white70,
                      size: 30,
                    ),
            ),
            title: Text(
              article.title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'by ${article.author}',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            trailing: canModify
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white70),
                        onPressed: () {
                          _showEditDialog(context, article);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white70),
                        onPressed: () {
                          _showDeleteDialog(context, article.id!);
                        },
                      ),
                    ],
                  )
                : null,
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
            author: article.author,
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
        backgroundColor: _backgroundGradient.colors.first.withOpacity(0.9),
        title: Text(
          'Delete article?',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.bold,),
        ),
        content: Text(
          'Are you sure you want to delete this article?',
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold,),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ArticleCubit>().deleteArticle(articleId);
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                  color: Colors.redAccent, fontWeight: FontWeight.bold,),
            ),
          ),
        ],
      ),
    );
  }
}
