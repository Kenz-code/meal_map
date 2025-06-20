import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/features/home/widgets/day_card.dart';

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

  final List<String> weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

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

  DateTime get _startOfWeek {
    // Adjust to Sunday as start of week
    return startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));

  }

  String _formatDate(DateTime date) {
    // e.g. Monday, May 27, 2025
    return DateFormat('EEEE, MMMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/meals/create'),
        child: Icon(Icons.add_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeWeek(-1),
                  iconSize: 16,
                  icon: Icon(Icons.arrow_back_ios_rounded),
                ),
                Text(
                  '${_formatDate(_startOfWeek)} - ${_formatDate(_startOfWeek.add(const Duration(days: 6)))}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => _changeWeek(1),
                  iconSize: 16,
                  icon: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
            const SizedBox(height:16),
            Expanded(
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = _startOfWeek.add(Duration(days: index));
                  final mealPlan = weekMeals[index];
                  final dayName = weekdayNames[date.weekday % 7];

                  return DayCard(date: date, mealPlan: mealPlan, index: index,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
