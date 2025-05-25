import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml

class Meal {
  String name;
  String cook;

  Meal({required this.name, required this.cook});
}

class MealPlan {
  Meal? breakfast;
  Meal? lunch;
  Meal? dinner;

  MealPlan({this.breakfast, this.lunch, this.dinner});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime startOfWeek = DateTime.now();
  late List<MealPlan> weekMeals;

  final List<String> weekdayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  @override
  void initState() {
    super.initState();
    _generateDummyMeals();
  }

  void _generateDummyMeals() {
    weekMeals = List.generate(7, (index) {
      return MealPlan(
        breakfast: Meal(name: 'Pancakes with Maple Syrup', cook: 'Mom'),
        lunch: Meal(name: 'Grilled Cheese Sandwich', cook: 'Dad'),
        dinner: Meal(name: 'Honey Garlic Chicken Mac n Cheese', cook: 'Ryland'),
      );
    });
  }

  void _changeWeek(int offset) {
    setState(() {
      startOfWeek = startOfWeek.add(Duration(days: 7 * offset));
      _generateDummyMeals(); // Replace with your real data load
    });
  }

  void _editMeal(String type, int dayIndex) {
    // Your edit/delete logic here
    debugPrint('Edit $type for day $dayIndex');
  }

  DateTime get _startOfWeek {
    // Adjust to Sunday as start of week
    return startOfWeek.subtract(Duration(days: startOfWeek.weekday % 7));
  }

  String _formatDate(DateTime date) {
    // e.g. Monday, May 27, 2025
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Meal Planner'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Text(
              'Week of ${_formatDate(_startOfWeek)} - ${_formatDate(_startOfWeek.add(const Duration(days: 6)))}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = _startOfWeek.add(Duration(days: index));
                  final mealPlan = weekMeals[index];
                  final dayName = weekdayNames[date.weekday % 7];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$dayName, ${_formatDate(date)}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 18),
                          _buildMealRow('Breakfast', mealPlan.breakfast, () => _editMeal('breakfast', index)),
                          const SizedBox(height: 14),
                          _buildMealRow('Lunch', mealPlan.lunch, () => _editMeal('lunch', index)),
                          const SizedBox(height: 14),
                          _buildMealRow('Dinner', mealPlan.dinner, () => _editMeal('dinner', index)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _changeWeek(-1),
                  child: const Text('◀ Previous Week', style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => _changeWeek(1),
                  child: const Text('Next Week ▶', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow(String mealLabel, Meal? meal, VoidCallback onLongPress) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              '$mealLabel:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                meal?.name ?? '—',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (meal?.cook != null) ...[
              const Icon(Icons.person, size: 18, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                meal!.cook,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
