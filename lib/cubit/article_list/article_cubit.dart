// lib/presentation/article/article_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/article_list/article_state.dart';
import 'package:my_project/domain/services/article_service.dart';
import 'package:my_project/domain/services/auth_service.dart'; // To get current user
import 'package:my_project/models/article.dart';

class ArticleCubit extends Cubit<ArticleState> {
  final ArticleService articleService;
  final AuthService authService;

  ArticleCubit({required this.articleService, required this.authService})
      : super(ArticleInitial());

  Future<void> loadArticles() async {
    emit(ArticleLoading());
    try {
      final articles = await articleService.getArticles();
      emit(ArticleLoaded(articles));
    } catch (e) {
      emit(ArticleError('Failed to load articles: ${e.toString()}'));
    }
  }

  Future<void> addArticle(
      String title, String content, String? imagePath) async {
    final author = (await authService.getCurrentUser()) ??
        'Unknown User'; // Get author from auth service
    final newArticle = Article(
      title: title,
      content: content,
      imagePath: imagePath,
      author: author,
    );
    try {
      await articleService.addArticle(newArticle);
      await loadArticles(); // Reload articles after adding
    } catch (e) {
      emit(ArticleError('Failed to add article: ${e.toString()}'));
    }
  }

  Future<void> updateArticle(Article article) async {
    try {
      await articleService.updateArticle(article);
      await loadArticles(); // Reload articles after updating
    } catch (e) {
      emit(ArticleError('Failed to update article: ${e.toString()}'));
    }
  }

  Future<void> deleteArticle(int articleId) async {
    try {
      await articleService.deleteArticle(articleId);
      await loadArticles(); // Reload articles after deleting
    } catch (e) {
      emit(ArticleError('Failed to delete article: ${e.toString()}'));
    }
  }

  // Method to check if current user can edit/delete an article
  Future<bool> canEditOrDelete(Article article) async {
    final currentUser = await authService.getCurrentUser();
    return currentUser == article.author;
  }
}
