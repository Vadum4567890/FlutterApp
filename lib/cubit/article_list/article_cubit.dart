// lib/presentation/article/article_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/article_list/article_state.dart';
import 'package:my_project/domain/services/article_service.dart';
import 'package:my_project/domain/services/auth_service.dart';
import 'package:my_project/models/article.dart';

/// Cubit for managing the state of articles.
/// It handles loading, adding, updating, and deleting articles.
class ArticleCubit extends Cubit<ArticleState> {
  final ArticleService articleService;
  final AuthService authService;

  ArticleCubit({required this.articleService, required this.authService})
      : super(ArticleInitial());

  /// Loads all articles from the service and emits [ArticleLoaded] state.
  /// Emits [ArticleLoading] during the process and [ArticleError] on failure.
  Future<void> loadArticles() async {
    emit(ArticleLoading());
    try {
      final articles = await articleService.getArticles();
      emit(ArticleLoaded(articles));
    } catch (e) {
      emit(ArticleError('Failed to load articles: ${e.toString()}'));
    }
  }

  /// Adds a new article.
  /// It first gets the current user as author, then calls the service to add the article.
  /// Finally, it reloads all articles to update the UI.
  Future<void> addArticle(
      String title, String content, String? imagePath) async {
    final author = (await authService.getCurrentUser()) ?? 'Unknown User';
    // Changed from Article.create to the main Article constructor
    final newArticle = Article(
      title: title,
      content: content,
      imagePath: imagePath,
      author: author,
    );
    try {
      await articleService.addArticle(newArticle);
      await loadArticles(); // Reload all articles to reflect the new addition
    } catch (e) {
      emit(ArticleError('Failed to add article: ${e.toString()}'));
    }
  }

  /// Updates an existing article.
  /// Calls the service to update the article and then reloads all articles.
  Future<void> updateArticle(Article article) async {
    try {
      await articleService.updateArticle(article);
      await loadArticles(); // Reload articles after updating
    } catch (e) {
      emit(ArticleError('Failed to update article: ${e.toString()}'));
    }
  }

  /// Deletes an article by its ID.
  /// Calls the service to delete the article and then reloads all articles.
  Future<void> deleteArticle(int articleId) async {
    try {
      await articleService.deleteArticle(articleId);
      await loadArticles(); // Reload articles after deleting
    } catch (e) {
      emit(ArticleError('Failed to delete article: ${e.toString()}'));
    }
  }

  /// Checks if the current authenticated user can edit or delete a given article.
  Future<bool> canEditOrDelete(Article article) async {
    final currentUser = await authService.getCurrentUser();
    return currentUser == article.author;
  }
}
