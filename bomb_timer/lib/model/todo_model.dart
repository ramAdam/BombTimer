// models/todo.dart
class Todo {
  final String id;
  final String text;
  bool isDone;

  Todo({
    required this.text,
    this.isDone = false,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
