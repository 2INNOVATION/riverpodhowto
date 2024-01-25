import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

List<String> names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eva',
  'Frank',
  'Grace',
  'Hank',
  'Ivy',
  'Jack'
];

final tickerProvder = StreamProvider.autoDispose((ref) => Stream.periodic(
      const Duration(
        seconds: 1,
      ),
      (i) => i + 1,
    ));

final namesProvider = StreamProvider.autoDispose((ref) {
  return ref
      .watch(
        tickerProvder.stream,
      )
      .map((
        count,
      ) =>
          names.getRange(
            0,
            count,
          ));
});

class TimerNames extends ConsumerWidget {
  const TimerNames({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("City Page"),
      ),
      body: Column(
        children: [
          names.when(
              data: (names) {
                return ListView.builder(
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(names.elementAt(index)),
                      );
                    });
              },
              error: (_, __) => const Text("Boh"),
              loading: () => const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )),
        ],
      ),
    );
  }
}
