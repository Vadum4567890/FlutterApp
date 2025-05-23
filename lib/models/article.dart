// lib/models/article.dart
import 'package:equatable/equatable.dart'; // Import equatable for proper object comparison

/// Represents an article with its details.
class Article extends Equatable {
  final int? id; // ID is now nullable, as it might not exist for new articles
  final String title;
  final String content;
  final String? imagePath;
  final String author;

  /// Main constructor for the Article class.
  /// The `id` is optional, primarily used when creating new articles before DB insertion.
  const Article({
    this.id, // Made nullable
    required this.title,
    required this.content,
    this.imagePath,
    required this.author,
  });

  /// Factory constructor for creating an [Article] object from a database map.
  /// Assumes 'id' is always present and an integer when retrieved from the DB.
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id']
          as int, // Cast directly to int, assuming it's never null from DB
      title: map['title'] as String,
      content: map['content'] as String,
      imagePath: map['imagePath'] as String?,
      author: map['author'] as String,
    );
  }

  /// Converts the [Article] object to a map suitable for database operations.
  /// Includes the `id` for updates.
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include id for updates
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'author': author,
    };
  }

  /// Converts the [Article] object to a map suitable for database insertion.
  /// Excludes the `id` field, as the database will generate it automatically.
  Map<String, dynamic> toMapWithoutId() {
    return {
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'author': author,
    };
  }

  /// Creates a copy of the [Article] object with optional new values.
  Article copyWith({
    int? id,
    String? title,
    String? content,
    String? imagePath,
    String? author,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      author: author ?? this.author,
    );
  }

  /// Overrides `props` from `Equatable` to enable value comparison for Article objects.
  @override
  List<Object?> get props => [id, title, content, imagePath, author];
}
