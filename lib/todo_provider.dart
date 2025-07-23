import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_turtrial/model/todo.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoListNotifier extends _$TodoListNotifier {
  @override
  List<Todo> build() => [];

  void add(Todo todo) {
    state = [...state, todo];
  }

  void update(int index, Todo updatedTodo) {
    final newList = [...state];
    newList[index] = updatedTodo;
    state = newList;
  }

  void remove(int index) {
    final newList = [...state]..removeAt(index);
    state = newList;
  }

}