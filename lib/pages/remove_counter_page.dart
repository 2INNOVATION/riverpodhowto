import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodhowto/main.dart';

class RemoveCounterPage extends ConsumerWidget {
  const RemoveCounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int counter = ref.watch(counterProvider);

    ref.listen<int>(counterProvider, (prev, next) {
      if (next < 0) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Contatore sotto zero"),
                actions: [
                  TextButton(
                      onPressed: () {
                        ref.invalidate(counterProvider);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Resetta contatore")),
                  TextButton(
                      onPressed: () {
                        ref.read(counterProvider.notifier).state++;
                        Navigator.of(context).pop();
                      },
                      child: const Text("Aggiungi +1")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Chiudi")),
                ],
              );
            });
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter page"),
      ),
      body: Center(
          child: Text(
        '$counter',
        style: Theme.of(context).textTheme.displayMedium,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(counterProvider.notifier).state--;
        },
        child: const Icon(Icons.remove),
      ),
    );
  }
}
