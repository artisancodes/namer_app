import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// MyAppState defines the data the app needs to function
// The State class extends ChangeNotifier, which means that it can notfy others
// about its own changes.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();

    // This method ensures that anyone watching MyAppState is notified.
    notifyListeners();
  }

  var favorites = <WordPair>{};

  void toggleFavorites() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The underscore at the start of _MyHomePageState makes that class private and
// is enforced by the compiler
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  // Every widget defines a build() method that's automatically called every time
  // the widget's circumstances changes so that the widget is always up to date.
  @override
  Widget build(BuildContext context) {
    Widget page;

    // Assigns a screen to page Widget, according to the current value in selectedIndex.
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        // Since there's no FavoritesPage yet, use Placholder (handy widget).
        page = Placeholder();
        break;
      default:
        // Throw and error if selectedIndex is neither 0 or 1
        // This helps prevent bugs.
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Every build method must return a widget or a nested tree of widgets.
    // In this case, the top-level widget is Scaffold.
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          // Column is one of the most basic layout widgets in Flutter.
          // I takes any numver of children and puts them in a column from top to bottom.
          body: Row(
        children: [
          // The SafeArea ensures that its child is not obscured by a hardware
          // notch or a status bar.
          SafeArea(
            // Widget that meant to be displayed at the left or right of an app
            // to navigate between a small number of views (between 3 and 5).
            // For smaller layouts, like mobile portrait, a BottomNavigationBar
            // should be used instead.
            child: NavigationRail(
              extended: constraints.maxWidth >= 600,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          // Using an Expanded widget makes a child of Row, Column, or Flex so that
          // the child fills the available space.
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ));
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MyHomePage tracks changes to the app's current state using the watch method.
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This widget takes appState, and accesses the only member of that
          // class (current).
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () => appState.toggleFavorites(),
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => appState.getNext(),
                child: Text('Next'),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // requests the app's current theme
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      // defines the card's color to be the same as the theme.
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "$pair.first $pair.second",
        ),
      ),
    );
  }
}
