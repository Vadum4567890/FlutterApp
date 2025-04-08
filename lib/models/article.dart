// ignore_for_file: always_put_required_named_parameters_first

class Article {
  int id;
  final String title;
  final String content;
  final String? imagePath;
  final String? author;

  Article({
    this.id = 0,
    required this.title,
    required this.content,
    this.imagePath,
    this.author,
  });

  static Article fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] as int? ?? 0, 
      title: map['title'] as String,
      content: map['content'] as String,
      imagePath: map['imagePath'] as String?,
      author: map['author'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'author': author,
    };
  }

  @override
  String toString() {
    return 'Article{id: $id, title: $title, content: $content, author: $author}';
  }
}
