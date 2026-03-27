import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/widgets/bottom_sheet_helper.dart';
import 'package:meal_map/core/widgets/confirm_dialog.dart';
import 'package:meal_map/features/ideas/data/ideas_firestore_datasource.dart';
import 'package:meal_map/features/ideas/models/meal_idea.dart';

class MealIdeaTile extends StatefulWidget {
  final MealIdea mealIdea;
  final VoidCallback refresh;
  const MealIdeaTile({Key? key, required this.mealIdea, required this.refresh}) : super(key: key);

  @override
  _MealIdeaTileState createState() => _MealIdeaTileState();
}

class _MealIdeaTileState extends State<MealIdeaTile> {

  Future<void> _onDeletePressed(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Delete Meal Idea'.text(),
        content: "Are you sure you want to delete ${widget.mealIdea.idea}?".text(),
        onConfirm: () => IdeasFirestoreDatasource().deleteMealIdea(widget.mealIdea.id),
      ),
    );

    if (shouldDelete == true) {
      context.pop();
      widget.refresh.call();
    }
  }

  void _editIdea() {
    BottomSheetHelper.show(
      minHeight: widget.mealIdea.notes == "" ? 200 : null,
      context: context,
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.delete_rounded),
                onPressed: () => _onDeletePressed(context),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.mealIdea.idea,
            style: context.textTheme.titleLarge,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${widget.mealIdea.type.capitalizeFirst()} • ${widget.mealIdea.person}",
            style: context.textTheme.labelMedium,
          ),

          24.gapHeight,

          Text(
            widget.mealIdea.notes,
            textAlign: TextAlign.left,
            style: context.textTheme.bodyMedium!.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _editIdea,
      child: ListTile(
        title: Text(widget.mealIdea.idea),
        subtitle: Text("${widget.mealIdea.type} • ${widget.mealIdea.person}"),
      ),
    );
  }
}
