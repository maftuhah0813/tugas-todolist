import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_page.dart';

class ToDoItem {
  String title;
  bool isDone;

  ToDoItem(this.title, this.isDone);

  Map<String, dynamic> toMap() => {'title': title, 'isDone': isDone};

  factory ToDoItem.fromMap(Map<String, dynamic> map) =>
      ToDoItem(map['title'], map['isDone']);
}

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomePage({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ToDoItem> todos = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  void loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('todo_list');
    if (data != null) {
      final List list = jsonDecode(data);
      setState(() {
        todos = list.map((e) => ToDoItem.fromMap(e)).toList();
      });
    }
  }

  void saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(todos.map((e) => e.toMap()).toList());
    prefs.setString('todo_list', data);
  }

  void addTodo() {
    if (controller.text.isNotEmpty) {
      setState(() {
        todos.add(ToDoItem(controller.text, false));
        controller.clear();
        saveTodos();
      });
    }
  }

  void toggleTodo(int index) {
    setState(() {
      todos[index].isDone = !todos[index].isDone;
      saveTodos();
    });
  }

  void removeTodo(int index) {
    setState(() {
      todos.removeAt(index);
      saveTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'To-Do List',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tugas Hari Ini:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan tugas baru...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: addTodo,
                  child: const Text(
                    'Tambah',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  todos.isEmpty
                      ? const Center(
                        child: Text(
                          'Belum ada tugas. Yuk tambah dulu!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final item = todos[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Checkbox(
                                value: item.isDone,
                                onChanged: (_) => toggleTodo(index),
                              ),
                              title: Text(
                                item.title,
                                style: TextStyle(
                                  decoration:
                                      item.isDone
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => removeTodo(index),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
