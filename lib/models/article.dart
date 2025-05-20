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
      id: map['id'] is int ? map['id'] as int : 0,
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      imagePath: map['imagePath']?.toString(),
      author: map['author']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'title': title,
      'content': content,
      'imagePath': imagePath,
      'author': author,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'Article{id: $id, title: $title, content: $content, author: $author}';
  }
}
