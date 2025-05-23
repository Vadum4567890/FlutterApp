import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int? id;
  final String title;
  final String content;
  final String? imagePath;
  final String author;

  const Article({
    required this.title, required this.content, required this.author, this.id,
    this.imagePath,
  });

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
