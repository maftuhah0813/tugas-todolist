import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(ToDoApp());

class ToDoItem {
  String title;
  bool isDone;

  ToDoItem(this.title, this.isDone);

  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone};
  }

  factory ToDoItem.fromMap(Map<String, dynamic> map) {
    return ToDoItem(map['title'], map['isDone']);
  }
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ToDoHome(),
    );
  }
}

class ToDoHome extends StatefulWidget {
  const ToDoHome({Key? key}) : super(key: key);

  @override
  ToDoHomeState createState() => ToDoHomeState();
}

class ToDoHomeState extends State<ToDoHome> {
  List<ToDoItem> _todos = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('todo_list');
    if (data != null) {
      final List list = jsonDecode(data);
      setState(() {
        _todos = list.map((e) => ToDoItem.fromMap(e)).toList();
      });
    }
  }

  void _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_todos.map((e) => e.toMap()).toList());
    prefs.setString('todo_list', data);
  }

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(ToDoItem(_controller.text, false));
        _controller.clear();
        _saveTodos();
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
      _saveTodos();
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
      _saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(title: Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Tambah tugas'),
                  ),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: _addTodo),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder:
                  (context, index) => ListTile(
                    title: Text(
                      _todos[index].title,
                      style: TextStyle(
                        color: Colors.white,
                        decoration:
                            _todos[index].isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    leading: Checkbox(
                      value: _todos[index].isDone,
                      onChanged: (value) => _toggleTodo(index),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTodo(index),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
