import 'package:my_project/models/article.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ArticleDatabase {
  static Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'articles.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE articles(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, author TEXT, imagePath TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<int> insertArticle(Article article) async {
    final db = await database;
    final id = await db.insert(
      'articles',
      article.toMapWithoutId(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  static Future<List<Article>> articles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');
    return List.generate(maps.length, (i) {
      return Article.fromMap(maps[i]);
    });
  }

  static Future<void> deleteArticle(int id) async {
    final db = await database;
    await db.delete(
      'articles',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateArticle(Article article) async {
    final db = await database;
    await db.update(
      'articles',
      article.toMap(),
      where: 'id = ?',
      whereArgs: [article.id],
    );
  }
}
