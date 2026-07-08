import 'package:meal_map/core/services/shared_prefs_service.dart';

class PreviousGroceryEntryHandler {
  PreviousGroceryEntryHandler._();

  static final instance = PreviousGroceryEntryHandler._();

  final String _sharedPrefsKey = "previous_grocery_entries";
  List<String> _groceries = [];

  List<String> get groceries => _groceries;

  List<String> loadPreviousGroceries() {
    final List<String> previousGroceryEntries = SharedPrefsService.instance.getStringList(_sharedPrefsKey) ?? [];
    _groceries = previousGroceryEntries;

    print(_groceries);

    return previousGroceryEntries;
  }

  void addGroceryEntry(String groceryEntry) {
    if (_groceries.contains(groceryEntry)) {
      return;
    }

    _groceries.add(groceryEntry);

    SharedPrefsService.instance.setStringList(
      _sharedPrefsKey,
      _groceries,
    );
  }
}