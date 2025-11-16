import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/features/home/data/meals_firestore_datasource.dart';
import 'package:meal_map/features/home/models/meal_data.dart';
import 'package:meal_map/features/home/models/meal_plan_ui.dart';
import 'package:meal_map/features/home/models/meal_ui.dart';
import 'package:meal_map/features/home/widgets/day_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime startOfWeek;
  late DateTime startOfThisWeek;
  late Future<List<MealData>> _futureMeals;
  List<DayCard> formattedMeals = [];

  bool showWeekBackArrow = false;
  bool showWeekForwardArrow = true;

  final List<String> weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _futureMeals = MealsFirestoreDatasource().loadAllMeals();
    startOfWeek = DateTime.now().weekday == DateTime.monday
        ? DateTime.now()
        : DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - DateTime.monday));
    startOfThisWeek = startOfWeek;
  }

  void _reloadMeals() {
    setState(() {
      _futureMeals = MealsFirestoreDatasource().loadAllMeals();
    });
  }

  DateTime lastMonday() {
    final d = DateTime.now().subtract(
        Duration(days: ((DateTime.now().weekday - DateTime.monday + 7) % 7)));
    return DateTime(d.year, d.month, d.day, 12);
  }

  int weekdayIndex(DateTime date) => (date.weekday + 6) % 7;

  void formatMeals(List<MealData> data) {
    formattedMeals = [];

    DateTime firstDay = lastMonday(); // two weeks behind
    DateTime lastDay = lastMonday().add(Duration(days: 28)); // two weeks ahead

    DateTime currentDay = firstDay;

    while (currentDay != lastDay) {
      MealPlan mealPlan = MealPlan();

      for (final meal in data) {
        if (meal.dateTime.month == currentDay.month && meal.dateTime.day == currentDay.day) {
          switch (meal.mealType) {
            case "Breakfast":
              mealPlan.breakfast = Meal(name: meal.mealName, cook: meal.cook);
              break;
            case "Lunch":
              mealPlan.lunch = Meal(name: meal.mealName, cook: meal.cook);
              break;
            case "Dinner":
              mealPlan.dinner = Meal(name: meal.mealName, cook: meal.cook);
              break;
          }
        }
      }

      DayCard dayCard = DayCard(
          date: currentDay,
          mealPlan: mealPlan,
          index: weekdayIndex(currentDay));

      formattedMeals.add(dayCard);

      currentDay = currentDay.add(Duration(days: 1));
    }
  }

  DayCard getDayCardFromDate(DateTime date) {
    for (final dc in formattedMeals) {
      if (dc.date.day == date.day && dc.date.month == date.month) {
        return dc;
      }
    }

    return formattedMeals[0];
  }

  bool isSameDayAndMonth(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month;
  }

  void _changeWeek(int offset) {
    DateTime firstDay = lastMonday(); // two weeks behind
    DateTime lastDay = lastMonday().add(Duration(days: 21)); // two weeks ahead

    setState(() {
      DateTime newStartOfWeek = startOfWeek.add(Duration(days: 7 * offset));

      startOfWeek = newStartOfWeek;

      if (isSameDayAndMonth(newStartOfWeek, firstDay)) {
        showWeekBackArrow = false;
      } else {
        showWeekBackArrow = true;
      }

      if (isSameDayAndMonth(newStartOfWeek, lastDay)) {
        showWeekForwardArrow = false;
      } else {
        showWeekForwardArrow = true;
      }
    });
  }

  DateTime get _startOfWeek {
    // Adjust to Sunday as start of week
    return startOfWeek.subtract(Duration(days: startOfWeek.weekday - 1));
  }

  String _formatDate(DateTime date) {
    // e.g. Monday, May 27, 2025
    return DateFormat('EEEE, MMM d').format(date);
  }

  void _onNewMealPressed() async {
    await context.push('/meals/create',
        extra: [lastMonday(), lastMonday().add(Duration(days: 21))]);

    // then reload
    _reloadMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onNewMealPressed,
        child: Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  showWeekBackArrow
                      ? IconButton(
                          onPressed: () => _changeWeek(-1),
                          iconSize: 16,
                          icon: Icon(Icons.arrow_back_ios_rounded),
                        )
                      : SizedBox.shrink(),
                  Row(
                    children: [
                      startOfThisWeek == startOfWeek
                          ? Container(
                              width: 16,
                              height: 16,
                              margin: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            )
                          : SizedBox.shrink(),
                      Text(
                        '${_formatDate(_startOfWeek)} - ${_formatDate(_startOfWeek.add(const Duration(days: 6)))}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  showWeekForwardArrow
                      ? IconButton(
                          onPressed: () => _changeWeek(1),
                          iconSize: 16,
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                        )
                      : SizedBox(
                          width: 32,
                        ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: FutureBuilder(
                  future: _futureMeals,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error loading meals');
                    } else {
                      final meals = snapshot.data ?? [];
                      if (meals.isEmpty) {
                        return Text('No meals saved yet.');
                      }

                      formatMeals(meals);

                      return ListView.builder(
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final date = _startOfWeek.add(Duration(days: index));

                          return getDayCardFromDate(date);
                        },
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
