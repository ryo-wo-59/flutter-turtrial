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
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetailPage(title: todo['title'] as String, todo: todo['description'] as String)
                    )
                  );
                  if (result == 'delete') {
                    setState(() {
                      todos.removeAt(index);
                    });
                  } else if (result != null) {
                    setState(() {
                      todos[index] = result as Map<String, Object>;
                    });
                  }
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
  final String title;
  final String todo;
  const TodoDetailPage({super.key, required this.todo, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('削除確認'),
                  content: const Text('このTodoを削除しますか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('キャンセル')
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('削除')
                    )
                  ]
                )
              );
              if (result == true) {
                Navigator.pop(context, 'delete');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedTodo = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTodoPage(todo: {'title': title, 'description': todo, 'colorCode': 100})
                )
              );
              if (updatedTodo != null) {
                Navigator.pop(context, updatedTodo);
              }
            },
          )
        ]
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

class EditTodoPage extends StatefulWidget {
  final Map<String, Object> todo;
  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = widget.todo['title'] as String;
    _description = widget.todo['description'] as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todoを編集')),
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  initialValue: _title,
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
                  initialValue: _description,
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