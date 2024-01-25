import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodhowto/models/todo.dart';

final providerTodoList =
    AsyncNotifierProvider<TodoList, List<Todo>>(TodoList.new);

class TodoList extends AsyncNotifier<List<Todo>> {
  @override
  FutureOr<List<Todo>> build() async {
    return Future.delayed(
      const Duration(seconds: 3),
      () => [
        Todo(
          description: 'Learn Flutter',
          completed: true,
          title: 'Master Flutter',
        ),
        Todo(
          description: 'Learn Riverpod',
          title: 'Master Flutter',
        ),
      ],
    );
  }

  Future<void> addTodo(Todo todo) async {
    // await API
    await Future.delayed(const Duration(seconds: 3), () async {
      final previousState = await future;
      state = AsyncData([...previousState, todo]);
    });
  }

  Future<void> modifyTodo(Todo todo) async {
    // await API
    await Future.delayed(const Duration(seconds: 3), () async {
      final previousState = await future;
      final index = previousState.indexOf(todo);

      previousState[index] = todo;
      previousState[index].completed = !previousState[index].completed;
      state = AsyncData([...previousState]);
    });
  }

  Future<void> removeTodo(Todo todo) async {
    // await API
    await Future.delayed(const Duration(seconds: 1), () async {
      final previousState = await future;
      previousState.remove(todo);
      state = AsyncData([...previousState, todo]);
    });
  }
}
