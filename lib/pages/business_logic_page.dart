import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodhowto/models/activity.dart';
import 'package:riverpodhowto/providers/provider_activity.dart';

class BusinessLogicPage extends StatelessWidget {
  const BusinessLogicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                "In questa pagina si sta utilizzando un business provider che fa una fetch ad una API."),
            const Text(
                "- Ogni volta che si esce dalla pagina la cache di questo FutureProvider non viene svuotata (funzione di default) [in questo caso abbiamo aggiunto .autoDispose per eliminare la cache]"),
            const Text(
                "- Per testare se è in cache si può tornare sul codice e fare semplicemente CMD+S, la console vi dirà che il Reload è stato eseguito, ma la fetch non verrà fatta nuovamente."),
            const Text(
                "- Abbiamo la possibilità di gestire in-line l'esito del business provider (Loading, Error, Data)"),
            const SizedBox(
              height: 50,
            ),
            Consumer(builder: (_, ref, ___) {
              final AsyncValue<Activity> activity = ref.watch(providerActivity);

              return activity.when(
                  data: (data) {
                    return Text('Activity: ${data.activity}');
                  },
                  error: (_, __) {
                    return const Text("Error");
                  },
                  loading: () => const CircularProgressIndicator());
            })
          ],
        ),
      ),
    );
  }
}
