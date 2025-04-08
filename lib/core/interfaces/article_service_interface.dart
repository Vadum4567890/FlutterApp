import 'package:my_project/models/article.dart';

abstract class ArticleServiceInterface {
  Future<List<Article>> getArticles();
  Future<void> addArticle(Article article);
  Future<void> updateArticle(Article article);
  Future<void> deleteArticle(int articleId);
}
