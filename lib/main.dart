import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodhowto/pages/add_counter_page%20copy.dart';
import 'package:riverpodhowto/pages/business_logic_page.dart';
import 'package:riverpodhowto/pages/city_page.dart';
import 'package:riverpodhowto/pages/contact_page.dart';
import 'package:riverpodhowto/pages/films_page.dart';
import 'package:riverpodhowto/pages/remove_counter_page.dart';
import 'package:riverpodhowto/pages/rubrica_page.dart';
import 'package:riverpodhowto/pages/timer_names.dart';
import 'package:riverpodhowto/pages/todo_page.dart';

final counterProvider = StateProvider<int>((ref) => 2);

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod How To',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddCounterPage()));
              },
              child: const Text("Add counter Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RemoveCounterPage()));
              },
              child: const Text("Remove counter Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const TodosPage()));
              },
              child: const Text("Todo Page Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FilmsPage()));
              },
              child: const Text("Films Page Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CityPage()));
              },
              child: const Text("Meteo Fake API Page Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BusinessLogicPage()));
              },
              child: const Text("Todo Fake API Page Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ContactPage()));
              },
              child: const Text("Complete Todo Fake API Page Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TimerNames()));
              },
              child: const Text("Strem Name Page Test >"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RubricaPage()));
              },
              child: const Text("Rubrica Modal Page Test >"),
            ),
          ],
        ),
      ),
    );
  }
}
