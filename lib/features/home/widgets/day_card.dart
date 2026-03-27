import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/widgets/bottom_sheet_helper.dart';
import 'package:meal_map/core/widgets/confirm_dialog.dart';
import 'package:meal_map/features/home/data/meals_firestore_datasource.dart';
import 'package:meal_map/features/home/models/meal_data.dart';
import 'package:meal_map/features/home/models/meal_plan_ui.dart';
import 'package:meal_map/features/home/widgets/meal_row.dart';

class DayCard extends StatefulWidget {
  final DateTime date;
  final MealPlan mealPlan;
  final int index;
  final VoidCallback refresh;

  const DayCard({
    super.key,
    required this.date,
    required this.mealPlan,
    required this.index,
    required this.refresh
  });

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;

  final _animationCurve = Curves.easeInOutCubic;
  final _animationDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
  }

  String _formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d').format(date);
  }

  bool isDayInThePast() {
    DateTime today = DateTime.now();
    // Remove time part for date-only comparison
    DateTime cardDate = DateTime(widget.date.year, widget.date.month, widget.date.day);
    DateTime nowDate = DateTime(today.year, today.month, today.day);
    return cardDate.isBefore(nowDate);
  }

  Future<void> _onDeletePressed(BuildContext context, MealData mealUi) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Delete Meal'.text(),
        content: "Are you sure you want to delete ${mealUi.mealName}?".text(),
        onConfirm: () => MealsFirestoreDatasource().deleteMeal(mealUi.getID()),
      ),
    );

    if (shouldDelete == true) {
      context.pop();
      widget.refresh.call();
    }
  }

  void _editDay(MealTypes mealType) {
    final MealData mealUi = widget.mealPlan.getMeal(mealType)!;

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
                onPressed: () => _onDeletePressed(context, mealUi),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            mealUi.mealName,
            style: context.textTheme.titleLarge,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${mealType.name.capitalizeFirst()} • ${mealUi.cook}",
            style: context.textTheme.labelMedium,
          ),

          24.gapHeight,

          Text(
            mealUi.notes ?? "",
            textAlign: TextAlign.left,
            style: context.textTheme.bodyMedium!.copyWith(color: context.colorScheme.onSurfaceVariant),
          ).visibleIf(mealUi.notes != null),
        ],
      ),
    );
  }

  bool dateIsNow() {
    return (widget.date.day == DateTime.now().day &&
        widget.date.month == DateTime.now().month);
  }

  bool get isEmptyMealPlan =>
      widget.mealPlan.breakfast == null &&
      widget.mealPlan.lunch == null &&
      widget.mealPlan.dinner == null;

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
                  style: isEmptyMealPlan || isDayInThePast() ? Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant) : Theme.of(context).textTheme.titleLarge,
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
              MealData? meal = widget.mealPlan.getMeal(MealTypes.values[index]);
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
