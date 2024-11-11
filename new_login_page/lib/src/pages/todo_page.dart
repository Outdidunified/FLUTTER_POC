import 'package:flutter/material.dart';
import 'package:login/src/models/todo.dart';
import 'todo_datapage.dart';



class TodosScreen extends StatelessWidget {

  // Example list of todos
  final List<Todo> todos = List.generate(
    20, (i) => Todo(
      title: 'Todo $i',
      description: 'A description of what needs to be done for Todo $i',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            // subtitle: Text(todo.description),
            onTap: () {
              // Navigate to the details screen and pass the Todo object
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoDetailScreen(todo: todo),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
