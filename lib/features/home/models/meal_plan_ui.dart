import 'package:meal_map/features/home/models/meal_data.dart';

enum MealTypes { breakfast, lunch, dinner }

class MealPlan {
  MealData? breakfast;
  MealData? lunch;
  MealData? dinner;

  MealPlan({this.breakfast, this.lunch, this.dinner});

  MealData? getMeal(MealTypes type) {
    switch (type) {
      case MealTypes.breakfast:
        return breakfast;
      case MealTypes.lunch:
        return lunch;
      case MealTypes.dinner:
        return dinner;
    }
  }
}
