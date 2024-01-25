import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Model
@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copy({required bool isFavorite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() =>
      "Film (id: $id, title: $title, description: $description, isFavorite: $isFavorite)";

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hashAll([id, isFavorite]);
}

//Data
const allFilms = [
  Film(
      id: "1",
      title: "Titolo Film 1",
      description: "Descrizione Film 1",
      isFavorite: false),
  Film(
      id: "2",
      title: "Titolo Film 2",
      description: "Descrizione Film 2",
      isFavorite: true),
  Film(
      id: "3",
      title: "Titolo Film 3",
      description: "Descrizione Film 3",
      isFavorite: false),
];

Future<List<Film>> getFilms() async {
  return Future.delayed(const Duration(seconds: 1), () => allFilms);
}

// CLASS STATE NOTIFIER
// ci mette a disposizione una variabile build-in chiamata state,
// che rappresenta il valore iniziale della classe. Il pro di questo "state" e
// che ha un notifier build-in, quindi quando modifichiamo questa variabile
// esegue un notify all di default, quindi non dobbiamo scriverlo noi manualmente.
class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier(super.state) {
    fetchFilms();
  }

  void fetchFilms() async {
    final films = await getFilms();
    state = films;
  }

  void update(Film film, bool isFavorite) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavorite: isFavorite)
            : thisFilm)
        .toList();
  }

  void add(Film film) {
    state = [...state, film];
  }
}

//Enum per filtrare
enum FavoriteStatus { all, favorite, notFavorite }

// PROVIDERS
// filtri
final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.all,
);

// films
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier([]),
);

// favorite films
final favoriteProvider = Provider<Iterable<Film>>((ref) {
  final allFilms = ref.watch(allFilmsProvider);
  return allFilms.where((film) => film.isFavorite);
});

// not-favorite films
final notFavoriteProvider = Provider<Iterable<Film>>((ref) {
  final allFilms = ref.watch(allFilmsProvider);
  return allFilms.where((film) => !film.isFavorite);
});

// WIDGET
class FilmsListWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;

  const FilmsListWidget({
    required this.provider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);

    return Expanded(
        child: ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films.elementAt(index);
              final favoriteIcon = film.isFavorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border);
              return ListTile(
                title: Text(film.title),
                subtitle: Text(film.description),
                trailing: IconButton(
                  icon: favoriteIcon,
                  onPressed: () {
                    final isFavorite = !film.isFavorite;

                    ref
                        .read(allFilmsProvider.notifier)
                        .update(film, isFavorite);
                  },
                ),
              );
            }));
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, ___) {
        return DropdownButton(
          value: ref.watch(favoriteStatusProvider),
          items: FavoriteStatus.values.map((fs) {
            return DropdownMenuItem(
                value: fs,
                child: Text(
                  fs.toString().split(".").last,
                ));
          }).toList(),
          onChanged: (FavoriteStatus? value) {
            ref.read(favoriteStatusProvider.notifier).state = value!;
          },
        );
      },
    );
  }
}

// PAGE ----
class FilmsDbPage extends ConsumerWidget {
  const FilmsDbPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Films"),
        ),
        body: Center(
          child: Column(
            children: [
              const FilterWidget(),
              Consumer(builder: (_, ref, ___) {
                final filter = ref.watch(favoriteStatusProvider);
                switch (filter) {
                  case FavoriteStatus.favorite:
                    return FilmsListWidget(provider: favoriteProvider);

                  case FavoriteStatus.notFavorite:
                    return FilmsListWidget(provider: notFavoriteProvider);

                  default:
                    return FilmsListWidget(provider: allFilmsProvider);
                }
              }),
              TextButton(
                onPressed: () async {
                  final filmToAdd = await createOrUpdateFilmDialog(context);
                  ref.read(allFilmsProvider.notifier).add(filmToAdd!);
                },
                child: const Text("Add film"),
              )
            ],
          ),
        ));
  }
}

//EXTRA ---
class CheckboxController extends ValueNotifier<bool> {
  CheckboxController({bool initialValue = false}) : super(initialValue);

  void toggle() {
    value = !value;
  }

  void setChecked(bool newValue) {
    value = newValue;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final titleController = TextEditingController();
final descriptionController = TextEditingController();
final isFavoriteController = CheckboxController();

Future<Film?> createOrUpdateFilmDialog(
  BuildContext context, [
  Film? existingFilm,
]) {
  String? id = existingFilm?.id ?? Uuid().v4();
  String? title = existingFilm?.title;
  String? description = existingFilm?.description;

  titleController.text = title ?? "";
  descriptionController.text = description?.toString() ?? "";
  CheckboxController? isFavoriteController =
      CheckboxController(initialValue: existingFilm?.isFavorite ?? false);

  return showDialog<Film?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Film"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "title",
                ),
                onChanged: (value) => title = value,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "description",
                ),
                onChanged: (value) => description = value,
              ),
              Checkbox(
                  value: isFavoriteController.value,
                  onChanged: (value) => isFavoriteController.toggle())
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(Film(
                    id: id,
                    description: description!,
                    title: title!,
                    isFavorite: isFavoriteController.value));
              },
              child: const Text("Save"),
            ),
          ],
        );
      });
}
