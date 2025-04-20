import 'package:flutter/material.dart';

class TodoDialogs {
  static void showAddTodoDialog(
    BuildContext context,
    void Function(String text) onAddTodo,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AddTodoDialog(
        onAddTodo: onAddTodo,
      ),
    );
  }
}

// Create a separate stateful widget for the dialog
class AddTodoDialog extends StatefulWidget {
  final void Function(String text) onAddTodo;

  const AddTodoDialog({required this.onAddTodo, super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void submitText() {
    if (textController.text.isNotEmpty) {
      widget.onAddTodo(textController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'ADD TASK',
        style: TextStyle(color: Colors.red),
      ),
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: textController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Enter task description',
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
        ),
        onSubmitted: (_) => submitText(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: submitText,
          child: const Text('ADD', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
