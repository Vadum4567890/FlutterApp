// ignore_for_file: inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/article_list/article_cubit.dart';
import 'package:my_project/cubit/article_list/article_state.dart';
import 'package:my_project/models/article.dart';
import 'package:my_project/screens/add_article_screen.dart';
import 'package:my_project/screens/article_detail_screen.dart';
import 'package:my_project/screens/edit_article_screen.dart';
import 'package:my_project/widgets/article_card.dart';
import 'package:my_project/widgets/gradient_background.dart';
import 'package:my_project/widgets/transparent_app_bar.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArticleCubit>().loadArticles();
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: TransparentAppBar(
        title: 'Articles',
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
      body: GradientBackground(
        child: SafeArea(
          child: BlocConsumer<ArticleCubit, ArticleState>(
            listener: _articleListener,
            builder: _articleBuilder,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddArticleScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _articleListener(BuildContext context, ArticleState state) {
    if (state is ArticleError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  Widget _articleBuilder(BuildContext context, ArticleState state) {
    if (state is ArticleLoading || state is ArticleInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ArticleError) {
      return Center(
        child: Text(
          'Error: ${state.message}',
          style: const TextStyle(color: Colors.red, fontSize: 18),
        ),
      );
    }

    if (state is ArticleLoaded) {
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
          return FutureBuilder<bool>(
            future: context.read<ArticleCubit>().canEditOrDelete(article),
            builder: (context, snapshot) {
              return ArticleCard(
                article: article,
                canModify: snapshot.data ?? false,
                onEdit: () => _showEditDialog(context, article),
                onDelete: () => _showDeleteDialog(context, article.id!),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                ),
              );
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  void _showEditDialog(BuildContext context, Article article) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => EditArticleDialog(
        article: article,
        onEdit: (title, content, imagePath) {
          final updatedArticle = article.copyWith(
            title: title,
            content: content,
            imagePath: imagePath,
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
