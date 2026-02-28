import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/meal_idea.dart';

class IdeasLocalDatasource {
  static const _key = "mealIdeaBank";

  static Future<void> saveMealIdea(MealIdea idea) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    list.add(jsonEncode(idea.toMap()));

    await prefs.setStringList(_key, list);
  }

  static Future<List<MealIdea>> loadMealIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];

    return list.map((e) {
      final decoded = jsonDecode(e);
      return MealIdea.fromMap(decoded);
    }).toList();
  }

  static Future<void> deleteMealIdea(String _id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(_key) ?? [];

    List<MealIdea> decodedList = list.map((e) {
      final decoded = jsonDecode(e);
      return MealIdea.fromMap(decoded);
    }).toList();

    for (final idea in decodedList) {
      if (idea.id == _id) {
        int index = decodedList.indexOf(idea);
        list.removeAt(index);
      }
    }

    await prefs.setStringList(_key, list);
  }

  static Future<void> clearMealIdeaDatabase() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
