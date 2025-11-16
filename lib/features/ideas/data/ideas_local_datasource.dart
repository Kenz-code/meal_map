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
}
