import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_turtrial/todo_provider.dart';
import 'package:flutter_turtrial/model/todo.dart';

void main() {
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
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

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('リストページ'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = todoList[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetailPage(index: index)
                    )
                  );
                  if (result == 'delete') {
                    ref.read(todoListNotifierProvider.notifier).remove(index);
                  }
                },
                child: Container(
                  height: 50,
                  color: Colors.amber[todo.colorCode],
                  child: Center(
                    child: Text('Entry ${todo.title}'),
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
            ref.read(todoListNotifierProvider.notifier).add(newTodo);
          }
        },
        child: const Icon(Icons.add),
      )
    );
    
  }
}


class TodoDetailPage extends ConsumerWidget {
  final int index;
  const TodoDetailPage({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListNotifierProvider);
    final todo = todoList[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
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
                  builder: (context) => EditTodoPage(todo: todo)
                )
              );
              if (updatedTodo != null) {
                ref.read(todoListNotifierProvider.notifier).update(index, updatedTodo);
              }
            },
          )
        ]
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail of ${todo.description}'),
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
                      Todo newTodo = Todo(
                        title: _title,
                        description: _description,
                        colorCode: 100 // 必要に応じて
                      );
                      // フォームが有効な場合の処理
                      Navigator.pop(context, newTodo);
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
  final Todo todo;
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
    _title = widget.todo.title;
    _description = widget.todo.description;
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
                      final updatedTodo = Todo(
                        title: _title,
                        description: _description,
                        colorCode: 100 // 必要に応じて
                      );
                      Navigator.pop(context, updatedTodo);
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