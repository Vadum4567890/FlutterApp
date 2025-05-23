// lib/domain/services/article_service.dart
import 'package:my_project/core/interfaces/article_service_interface.dart';
import 'package:my_project/data/local/article_database.dart';
import 'package:my_project/models/article.dart';

/// Service class for handling article-related business logic and data operations.
/// It acts as an intermediary between the Cubit and the data source (ArticleDatabase).
class ArticleService implements ArticleServiceInterface {
  @override
  Future<List<Article>> getArticles() async {
    return await ArticleDatabase.articles();
  }

  @override

  /// Adds a new article to the database.
  /// Returns the newly created Article object, including its database-generated ID.
  Future<Article> addArticle(Article article) async {
    final id = await ArticleDatabase.insertArticle(article);
    // Use the copyWith method to create a new Article instance
    // with the ID assigned by the database, without using a private constructor.
    return article.copyWith(id: id);
  }

  @override
  Future<void> updateArticle(Article article) async {
    await ArticleDatabase.updateArticle(article);
  }

  @override
  Future<void> deleteArticle(int articleId) async {
    await ArticleDatabase.deleteArticle(articleId);
  }
}
