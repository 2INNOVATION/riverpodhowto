class Todo {
  Todo({
    required this.title,
    required this.description,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'] as String,
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );
  }

  final String title;
  final String description;
  bool completed;
}
