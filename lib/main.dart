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
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
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
}

class MyHomePage extends StatelessWidget {
  // Every widget defines a build() method that's automatically called every time
  // the widget's circumstances changes so that the widget is always up to date.
  @override
  Widget build(BuildContext context) {
    // MyHomePage tracks changes to the app's current state using the watch method.
    var appState = context.watch<MyAppState>();

    // Every build method must return a widget or a nested tree of widgets.
    // In this case, the top-level widget is Scaffold.
    return Scaffold(
      // Column is one of the most basic layout widgets in Flutter.
      // I takes any numver of children and puts them in a column from top to bottom.
      body: Column(
        children: [
          Text('A random AWESOME ideia: '),
          // This widget takes appState, and accesses the only member of that
          // class (current).
          Text(appState.current.asLowerCase),
          ElevatedButton(
            onPressed: () => appState.getNext(),
            child: Text('Next'),
          )
        ],
      ),
    );
  }
}
