import 'package:flutter/material.dart';
import 'package:meal_map/features/home/models/meal_ui.dart';

class MealRow extends StatelessWidget {
  final String mealLabel;
  final Meal? meal;
  final VoidCallback onLongPress;

  const MealRow(
      {super.key,
      required this.mealLabel,
      required this.meal,
      required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: Row(
          children: [
            Text('$mealLabel:',
                style: meal?.name != null
                    ? Theme.of(context).textTheme.labelLarge
                    : Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                meal?.name ?? '—',
                style: meal?.name != null
                    ? Theme.of(context).textTheme.bodyLarge
                    : Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
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
