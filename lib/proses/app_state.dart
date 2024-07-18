import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

// Application state class that holds data and business logic
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  // Generates the next word pair and updates the history
  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  // Toggles the favorite status of a word pair
  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  // Removes a word pair from the favorites list
  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
