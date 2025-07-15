import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/features/home/models/meal_plan_ui.dart';
import 'package:meal_map/features/home/models/meal_ui.dart';
import 'package:meal_map/features/home/widgets/meal_row.dart';

class DayCard extends StatefulWidget {
  final DateTime date;
  final MealPlan mealPlan;
  final int index;

  const DayCard({
    super.key,
    required this.date,
    required this.mealPlan,
    required this.index,
  });

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;

  final _animationCurve = Curves.easeInOutCubic;
  final _animationDuration = const Duration(milliseconds: 300);

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  void _editDay(int dayIndex) {
    debugPrint('Edit for day $dayIndex');
  }

  bool dateIsNow() {
    return (widget.date.day == DateTime.now().day &&
        widget.date.month == DateTime.now().month);
  }

  bool get isEmptyMealPlan =>
      widget.mealPlan.breakfast?.name == null &&
      widget.mealPlan.lunch?.name == null &&
      widget.mealPlan.dinner?.name == null;

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
            /// Header row
            Row(
              children: [
                if (dateIsNow())
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                if (dateIsNow()) const SizedBox(width: 8),
                Text(
                  _formatDate(widget.date),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),

                /// Animated expand/collapse icon
                SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isCollapsed = !isCollapsed;
                      });
                    },
                    padding: EdgeInsets.zero,
                    icon: AnimatedRotation(
                      turns: isCollapsed ? 0 : 0.5,
                      duration: _animationDuration,
                      curve: _animationCurve,
                      child: const Icon(Icons.expand_more_rounded),
                    ),
                    tooltip: isCollapsed ? 'Expand' : 'Collapse',
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),

            /// Animated content
            _buildContent()
          ],
        ),
      ),
    );
  }

  Widget _buildContent() => AnimatedSize(
        duration: _animationDuration,
        curve: _animationCurve,
        child: isCollapsed
            ? !isEmptyMealPlan
                ? _buildCollapsedUnemptyContent()
                : SizedBox.shrink()
            : Column(
                children: [
                  const SizedBox(height: 16),
                  MealRow(
                    mealLabel: "Breakfast",
                    meal: widget.mealPlan.breakfast,
                    onLongPress: () => _editDay(widget.index),
                  ),
                  const SizedBox(height: 8),
                  MealRow(
                    mealLabel: "Lunch",
                    meal: widget.mealPlan.lunch,
                    onLongPress: () => _editDay(widget.index),
                  ),
                  const SizedBox(height: 8),
                  MealRow(
                    mealLabel: "Dinner",
                    meal: widget.mealPlan.dinner,
                    onLongPress: () => _editDay(widget.index),
                  ),
                ],
              ),
      );

  Widget _buildCollapsedUnemptyContent() => Column(
        children: [
          const SizedBox(height: 16),
          Column(
            children: List.generate(MealTypes.values.length, (index) {
              Meal? meal = widget.mealPlan.getMeal(MealTypes.values[index]);
              if (meal != null) {
                return Column(
                  children: [
                    MealRow(
                      mealLabel: MealTypes.values[index].name
                              .toString()[0]
                              .toUpperCase() +
                          MealTypes.values[index].name.toString().substring(1),
                      meal: widget.mealPlan.getMeal(MealTypes.values[index]),
                      onLongPress: () => _editDay(widget.index),
                    ),
                    MealTypes.values[index] != MealTypes.dinner
                        ? SizedBox(
                            height: 8,
                          )
                        : SizedBox.shrink()
                  ],
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ),
        ],
      );
}
