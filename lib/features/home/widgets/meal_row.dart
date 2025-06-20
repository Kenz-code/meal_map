import 'package:flutter/material.dart';
import 'package:meal_map/features/home/screens/meals_page.dart';

class MealRow extends StatelessWidget {
  final String mealLabel;
  final Meal? meal;
  final VoidCallback onLongPress;

  const MealRow({super.key, required this.mealLabel, required this.meal, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: Row(
          children: [
            Text(
                '$mealLabel:',
                style: Theme.of(context).textTheme.labelLarge
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                meal?.name ?? '—',
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (meal?.cook != null) ...[
              const Icon(Icons.person, size: 16),
              const SizedBox(width: 6),
              Text(
                meal!.cook,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
