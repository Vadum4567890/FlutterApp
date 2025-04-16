// lib/domain/models/article_database.dart

// ignore_for_file: depend_on_reference
import 'package:my_project/models/article.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ArticleDatabase {
  static Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'articles.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, content TEXT, author TEXT, imagePath TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertArticle(Article article) async {
    final db = await database;
    // Вставка статті та отримання згенерованого ID
    final id = await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    article.id = id;  
  }

  static Future<List<Article>> articles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');
    return List.generate(maps.length, (i) {
      return Article(
        id: maps[i]['id'] as int? ?? 0,  // Значення за замовчуванням
        title: maps[i]['title'] as String? ?? '',
        content: maps[i]['content'] as String? ?? '',
        imagePath: maps[i]['imagePath'] as String?,
        author: maps[i]['author'] as String? ?? '',
      );
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
