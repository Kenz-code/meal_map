import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/widgets/bottom_sheet_helper.dart';
import 'package:meal_map/features/ideas/data/ideas_local_datasource.dart';
import 'package:meal_map/features/ideas/models/meal_idea.dart';

class MealIdeaTile extends StatefulWidget {
  final MealIdea mealIdea;
  const MealIdeaTile({Key? key, required this.mealIdea}) : super(key: key);

  @override
  _MealIdeaTileState createState() => _MealIdeaTileState();
}

class _MealIdeaTileState extends State<MealIdeaTile> {

  void _onDeletePressed() {
    IdeasLocalDatasource.deleteMealIdea(widget.mealIdea.id);
    context.pop();
  }

  void _editIdea() {
    BottomSheetHelper.show(
      context: context,
      child: Column(
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
            widget.mealIdea.type.capitalizeFirst(),
            style: context.textTheme.labelLarge,
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
