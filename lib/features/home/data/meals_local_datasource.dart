import 'package:meal_map/core/services/shared_prefs_service.dart';
import 'package:meal_map/features/home/models/meal_data.dart';

class MealsLocalDatasource {
  static final prefs = SharedPrefsService.instance;

  static Future<void> saveMeal(MealData mealData) async {
    await prefs.saveMap(mealData.getID(), mealData.toMap());
  }

  static Future<MealData> loadMeal(String id) async {
    final map = await prefs.loadMap(id);
    return MealData.fromMap(map);
  }

  static Future<List<MealData>> loadAllMeals() async {
    final keys = prefs.getKeys();

    List<MealData> meals = [];

    for (final key in keys) {
      if (RegExp(r'^\d+$').hasMatch(key)) {
        final value = await loadMeal(key);
        meals.add(value);
      }
    }

    return meals;
  }
}
