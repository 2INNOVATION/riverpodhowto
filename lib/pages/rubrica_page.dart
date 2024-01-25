import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// !!!! ChangeNotifierProvider
///
/// ChangeNotifier è utilizzato per ascoltare i cambiamenti di interi oggetti.
/// L'unico problema è che non dice cosa è stato cambiato nel oggetto ma che qualcosa è stato cambiato
/// quindi forza un update generale per ricalcolare la UI dall'inizio.
///

@immutable
class Person {
  final String name;
  final int age;
  final String uuid;

  Person({
    required this.age,
    required this.name,
    String? uuid,
  }) : uuid = uuid ??
            const Uuid()
                .v4(); //Se non si passa il UUID questo metodo lo imposta in automatico

  // Metodo per aggiornare la persona
  Person updated([String? name, int? age]) =>
      Person(age: age ?? this.age, name: name ?? this.name, uuid: uuid);

  // Getter del nome
  String get displayName => "$name ($age years old)";

  // Metodo per verificare se una classe Person è uguale ad un'altra classe person
  // Si fa il override per definire il criterio di comparazione che in questo caso
  // Viene impostato su uuid, quindi la comparazione è effettuata solo su questa key
  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => "Person (name: $name, age: $age, uuid: $uuid)";
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void add(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void remove(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person person) {
    final index = _people.indexOf(person);
    final old = _people[index];
    if (old.name != person.name || old.age != person.age) {
      _people[index] = old.updated(person.name, person.age);
    }
    notifyListeners();
  }
}

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context, [
  Person? existingPerson,
]) {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  nameController.text = name ?? "";
  ageController.text = age?.toString() ?? "";

  return showDialog<Person?>(
      context: context,
      builder: (context) {
        return Consumer(builder: (context, ref, child) {
          final datamodel = ref.watch(peopleProvider);
          return AlertDialog(
            title: Text("Create Person n*${datamodel.count}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "name",
                  ),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: "age",
                  ),
                  onChanged: (value) => age = int.tryParse(value),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  if (name != null || age != null) {
                    if (existingPerson != null) {
                      // Update person
                      final newPerson = existingPerson.updated(name, age);
                      Navigator.of(context).pop(newPerson);
                    } else {
                      // Create new person
                      Navigator.of(context).pop(Person(age: age!, name: name!));
                    }
                  } else {
                    // No data, close dialog as error
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Save"),
              ),
            ],
          );
        });
      });
}

final peopleProvider = ChangeNotifierProvider(
  (ref) => DataModel(),
);

final peopleYoung = Provider((ref) {
  final peopleRef = ref.watch(peopleProvider);
  return peopleRef.people.where((person) => person.age < 40).length;
});

class RubricaPage extends ConsumerWidget {
  const RubricaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Consumer(
            builder: (context, ref, child) {
              final youngs = ref.watch(peopleYoung);
              return Text("Giovani ${youngs}");
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer(builder: (_, ref, ___) {
                final dataModel = ref.watch(peopleProvider);

                return Expanded(
                  child: ListView.builder(
                    itemCount: dataModel.count,
                    itemBuilder: (context, index) {
                      final person = dataModel.people[index];
                      return ListTile(
                        title: GestureDetector(
                          child: Text(person.displayName),
                          onTap: () async {
                            final updatedPerson =
                                await createOrUpdatePersonDialog(
                              context,
                              person,
                            );
                            if (updatedPerson != null) {
                              dataModel.update(updatedPerson);
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        floatingActionButton: Consumer(builder: (_, ref, ___) {
          return FloatingActionButton(
            onPressed: () async {
              final person = await createOrUpdatePersonDialog(
                context,
              );
              if (person != null) {
                final dataModel = ref.read(peopleProvider);
                dataModel.add(person);
              }
            },
            tooltip: 'Create person',
            child: const Icon(Icons.add),
          );
        }));
  }
}
