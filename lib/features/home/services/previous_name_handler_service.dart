import 'package:meal_map/core/services/shared_prefs_service.dart';

class PreviousNameHandlerService {
  PreviousNameHandlerService._();

  static final instance = PreviousNameHandlerService._();

  final String _sharedPrefsKey = "previous_names";
  List<String> _names = [];

  List<String> get names => _names;

  List<String> loadPreviousNames() {
    final List<String> previousNames = SharedPrefsService.instance.getStringList(_sharedPrefsKey) ?? [];
    _names = previousNames;

    print(_names);

    return previousNames;
  }

  void addName(String name) {
    if (_names.contains(name)) {
      return;
    }

    _names.add(name);

    SharedPrefsService.instance.setStringList(
      _sharedPrefsKey,
      _names,
    );
  }
}