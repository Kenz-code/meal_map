import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/features/home/models/meal_plan_ui.dart';
import 'package:meal_map/features/home/widgets/meal_row.dart';

class DayCard extends StatelessWidget {
  final DateTime date;
  final MealPlan mealPlan;
  final int index;

  const DayCard(
      {super.key,
      required this.date,
      required this.mealPlan,
      required this.index});

  String _formatDate(DateTime date) {
    // e.g. Monday, May 27, 2025
    return DateFormat('EEEE, MMMM d').format(date);
  }

  void _editDay(int dayIndex) {
    // Your edit/delete logic here
    debugPrint('Edit for day $dayIndex');
  }

  bool dateIsNow() {
    return (date.day == DateTime.now().day &&
        date.month == DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                dateIsNow()
                    ? Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      )
                    : SizedBox.shrink(),
                dateIsNow()
                    ? SizedBox(
                        width: 8,
                      )
                    : SizedBox.shrink(),
                Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            MealRow(
                mealLabel: "Breakfast",
                meal: mealPlan.breakfast,
                onLongPress: () => _editDay(index)),
            const SizedBox(height: 8),
            MealRow(
                mealLabel: "Lunch",
                meal: mealPlan.lunch,
                onLongPress: () => _editDay(index)),
            const SizedBox(height: 8),
            MealRow(
                mealLabel: "Dinner",
                meal: mealPlan.dinner,
                onLongPress: () => _editDay(index)),
          ],
        ),
      ),
    );
  }
}
