import 'meal_ui.dart';

enum MealTypes { breakfast, lunch, dinner }

class MealPlan {
  Meal? breakfast;
  Meal? lunch;
  Meal? dinner;

  MealPlan({this.breakfast, this.lunch, this.dinner});

  Meal? getMeal(MealTypes type) {
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
