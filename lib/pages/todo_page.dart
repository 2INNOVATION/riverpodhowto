import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todos extends StateNotifier<List<String>> {
  Todos() : super([]);
  void addTodo(String input) => state = [...state, input];
  List<String>? get value => state;
}

final todosProvider = StateNotifierProvider<Todos, List<String>>((ref) {
  return Todos();
});

class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> list = ref.watch(todosProvider);

    final TextEditingController controller = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Todos page"),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Inserisci il testo',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String inputText = controller.text;
                ref.read(todosProvider.notifier).addTodo(inputText);
              },
              child: const Text('Conferma'),
            ),
            Text(list.length.toString()),
          ],
        ));
  }
}
