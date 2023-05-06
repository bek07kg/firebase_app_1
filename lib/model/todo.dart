class Todo {
  Todo({
    required this.title,
    this.description,
    required this.isselect,
    required this.author,
    this.id,
  });
  final String title;
  final String? description;
  final bool isselect;
  final String author;
  String? id;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'isselect': isselect,
      'author': author,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      title: map['title'] as String,
      description: map['description'] != map ? ['description'] as String : null,
      isselect: map['isselect'] as bool,
      author: map['author'] as String,
    );
  }
}
