// widgets/todo_list_widget.dart
import 'package:bomb_timer/bomb_timer_controller.dart';
import 'package:bomb_timer/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BombTimerController>(context);

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: Column(
        children: [
          Text('TASKS', style: TextStyle(color: Colors.red)),
          for (final todo in controller.todos)
            CheckboxListTile(
              value: todo.isDone,
              onChanged: (_) => controller.toggleTodoStatus(todo.id),
              title: Text(todo.text),
            ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.red),
            onPressed: () => TodoDialogs.showAddTodoDialog(
                context, (text) => controller.addTodo(text)),
          ),
        ],
      ),
    );
  }
}
