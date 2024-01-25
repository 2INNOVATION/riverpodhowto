import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodhowto/providers/provider_todo.dart';

final providerTodosCompleted = Provider((ref) {
  final todos = ref.watch(providerTodoList);
  return todos.when(
      data: (data) => data.where((element) => element.completed).toList(),
      error: (_, __) => [],
      loading: () => []);
});
