import 'package:my_project/core/interfaces/article_service_interface.dart';
import 'package:my_project/data/local/article_database.dart';
import 'package:my_project/models/article.dart';

class ArticleService implements ArticleServiceInterface {
  @override
  Future<List<Article>> getArticles() async {
    return await ArticleDatabase.articles();
  }

  @override
  Future<void> addArticle(Article article) async {
    await ArticleDatabase.insertArticle(article);
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
