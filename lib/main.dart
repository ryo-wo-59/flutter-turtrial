import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'サンプルアプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ListPage(),
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  static const List<Object> todos = <Object>[
    {'title': 'Todo 1', 'description': 'Description 1', 'colorCode': 100},
    {'title': 'Todo 2', 'description': 'Description 2', 'colorCode': 200},
    {'title': 'Todo 3', 'description': 'Description 3', 'colorCode': 300},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('リストページ'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: todos.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todos[index] as Map<String, Object>;
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetailPage(todo: todo["description"] as String)
                    )
                  );
                },
                child: Container(
                  height: 50,
                  color: Colors.amber[todo["colorCode"] as int],
                  child: Center(
                    child: Text('Entry ${todo["title"] as String}'),
                  ),
                ),
              ),
              Divider(),
            ]
          );
        }
      ),
    );
  }
}

class TodoDetailPage extends StatelessWidget {
  final String todo;
  const TodoDetailPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail of $todo'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('戻る'),
            ),
          ],
        )
      ),
    );
  }
}

