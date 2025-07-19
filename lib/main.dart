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

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<Map<String, Object>> todos = [
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
          final todo = todos[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () async{
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetailPage(todo: todo['description'] as String)
                    )
                  );
                },
                child: Container(
                  height: 50,
                  color: Colors.amber[todo['colorCode'] as int],
                  child: Center(
                    child: Text('Entry ${todo['title']}'),
                  ),
                ),
              ),
              const Divider(),
            ]
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTodo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage())
          );
          if (newTodo != null) {
            setState(() {
              todos.add(newTodo);
            });
          }
        },
        child: const Icon(Icons.add),
      )
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

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todoを追加')),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                  ),
                  onSaved: (String? value) {
                    _title = value ?? '';
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'タイトルを入力してください';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '詳細',
                  ),
                  onSaved: (String? value) {
                    _description = value ?? '';
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return '詳細を入力してください';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); 
                      // フォームが有効な場合の処理
                      Navigator.pop(context, {
                        'title': _title,
                        'description': _description,
                        'colorCode': 100, // 必要に応じて
                      });
                    }
                  },
                  child: const Text('保存'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
