import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum City { roma, milano, parigi }

typedef MeteoEmoticon = String;
const sconoscitoMeteoEmoticon = "BOH";

Future<MeteoEmoticon> getMeteo(City city) {
  return Future.delayed(
      const Duration(seconds: 1),
      () => {
            City.milano: "🌦️",
            City.parigi: "⛅️",
            City.roma: "🌤️",
          }[city]!);
}

// ------

// UI write this and read from this:
// sarà il handler della città selezionata
final currentCityProvider = StateProvider<City?>((ref) => null);

// UI read this:
// questo è il wrapper che servirà per elaborare il "currentCityProvider"
final meteoProvider = FutureProvider<MeteoEmoticon>((ref) {
  final citySelezionata = ref.watch(currentCityProvider);
  if (citySelezionata != null) {
    return getMeteo(citySelezionata);
  } else {
    return sconoscitoMeteoEmoticon;
  }
});

class CityPage extends ConsumerWidget {
  const CityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String> meteo = ref.watch(
      meteoProvider,
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("City Page"),
        ),
        body: Column(
          children: [
            meteo.when(
                data: (data) {
                  return Text(
                    data,
                    style: const TextStyle(fontSize: 40),
                  );
                },
                error: (_, __) => const Text("BOH"),
                loading: () => const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    )),
            Expanded(
              child: ListView.builder(
                itemCount: City.values.length,
                itemBuilder: (context, index) {
                  final citta = City.values[index];
                  final isSelected = citta == ref.watch(currentCityProvider);
                  return ListTile(
                    title: Text(
                      citta.toString(),
                    ),
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () {
                      ref.read(currentCityProvider.notifier).state = citta;
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
