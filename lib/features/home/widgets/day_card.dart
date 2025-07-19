import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/widgets/bottom_sheet_helper.dart';
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

  void _editDay(MealTypes mealType) {
    BottomSheetHelper.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit_rounded),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.delete_rounded),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            widget.mealPlan.getMeal(mealType)!.name,
            style: context.textTheme.titleLarge,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            mealType.name.capitalizeFirst(),
            style: context.textTheme.labelLarge,
          ),
        ],
      ),
    );
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
                    onLongPress: () => _editDay(MealTypes.breakfast),
                  ),
                  const SizedBox(height: 8),
                  MealRow(
                    mealLabel: "Lunch",
                    meal: widget.mealPlan.lunch,
                    onLongPress: () => _editDay(MealTypes.lunch),
                  ),
                  const SizedBox(height: 8),
                  MealRow(
                    mealLabel: "Dinner",
                    meal: widget.mealPlan.dinner,
                    onLongPress: () => _editDay(MealTypes.dinner),
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
                      mealLabel: MealTypes.values[index].name.capitalizeFirst(),
                      meal: widget.mealPlan.getMeal(MealTypes.values[index]),
                      onLongPress: () => _editDay(MealTypes.values[index]),
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
