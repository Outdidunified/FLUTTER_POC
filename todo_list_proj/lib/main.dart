import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<String> _todos = [];

  @override

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTodo = "";
        return AlertDialog(
          title: const Text("Add a new To-Do"),
          content: TextField(
            onChanged: (value) {
              newTodo = value;
            },
          ),

          actions: [
            ElevatedButton(
              onPressed: () {

                setState(() {
                  if (newTodo.isNotEmpty) {
                    _todos.add(newTodo);
                  }
                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            ),
          ],

        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
            itemCount: _todos.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    _todos[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon:const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _todos.removeAt(index);

                      });
                    },
                  ),
                ),
              );
            },
          ),


      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}