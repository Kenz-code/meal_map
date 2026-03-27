import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/core/extensions/context_theme_extensions.dart';
import 'package:meal_map/core/extensions/string_casing_extension.dart';
import 'package:meal_map/core/widgets/bottom_sheet_helper.dart';
import 'package:meal_map/features/home/models/meal_plan_ui.dart';
import 'package:meal_map/features/ideas/data/ideas_firestore_datasource.dart';
import 'package:meal_map/features/ideas/models/meal_idea.dart';
import 'package:meal_map/features/ideas/widgets/meal_idea_tile.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  List<MealIdea> ideaBank = [];
  List<String> allTheNames = [];

  List<String> mealTypeFilters = [];
  List<String> nameFilters = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBank();
  }

  Future<void> _loadBank() async {
    final bank = await IdeasFirestoreDatasource().loadMealIdeas();

    // get all the names
    List<String> bankNames = [];
    for (MealIdea idea in bank) {
      if (bankNames.contains(idea.person) == false) {
        bankNames.add(idea.person);
      }
    }

    setState(() {
      ideaBank = bank;
      allTheNames = bankNames;
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
      _loadBank();
    });
  }

  Future<void> _goToAddPage() async {
    await context.push('/ideas/create');
    await _loadBank(); // reload bank after adding ideas
  }

  void _resetAllFilters() {
    setState(() {
      mealTypeFilters.clear();
      nameFilters.clear();
    });
  }

  void _onFilterPressed() {
    BottomSheetHelper.show(
      minHeight: 0,
      context: context,
      child: StatefulBuilder(
        builder: (context, setSheetState) {
          void rebuildBoth(VoidCallback fn) {
            // Update the state data immediately
            fn();
            // Rebuild the sheet now
            setSheetState(() {});
            // Defer the page rebuild to after the current frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() {});
            });
          }

          Widget buildFilterTile(String title, List<String> filterList) {
            final isChecked = filterList.contains(title);
            return CheckboxListTile(
              dense: true,
              title: title.text(),
              value: isChecked,
              onChanged: (newValue) => rebuildBoth(() {
                if (newValue == true) {
                  filterList.add(title);
                } else {
                  filterList.remove(title);
                }
              }),
            );
          }


          return Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: "Reset".text().textButton(
                  onPressed: () => rebuildBoth(_resetAllFilters),
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero)
                  )
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  8.gapHeight,

                  "Filters".text(style: context.textTheme.titleLarge),

                  32.gapHeight,

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          "Names".text(style: context.textTheme.titleSmall),

                          8.gapHeight,

                          ...allTheNames.map((name) => buildFilterTile(name, nameFilters))
                        ],
                      ).expanded1,

                      VerticalDivider(),

                      <Widget>[
                        "Meal Types".text(style: context.textTheme.titleSmall),

                        8.gapHeight,

                        buildFilterTile(MealTypes.breakfast.name.capitalizeFirst(), mealTypeFilters),
                        buildFilterTile(MealTypes.lunch.name.capitalizeFirst(), mealTypeFilters),
                        buildFilterTile(MealTypes.dinner.name.capitalizeFirst(), mealTypeFilters),
                      ].column().expanded1,
                    ],
                  ),

                  8.gapHeight,

                  "Apply Filters".text().outlinedButton(onPressed: () {context.pop();}),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Ideas"),
        centerTitle: true,
        actions: [
          Icon(Icons.filter_alt_rounded).button(
            onPressed: _onFilterPressed,
          ).visibleIf(_isLoading == false),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return CircularProgressIndicator().center();
          }

          final filteredIdeas = ideaBank.where((idea) {
            // If nameFilters is empty, show all. Otherwise, check if idea.person is in the list.
            final matchesName = nameFilters.isEmpty || nameFilters.contains(idea.person);

            // If mealTypeFilters is empty, show all. Otherwise, check if idea.type matches.
            // Note: Ensure capitalization matches what you use in the buildFilterTile
            final matchesType = mealTypeFilters.isEmpty ||
                mealTypeFilters.contains(idea.type.capitalizeFirst());

            return matchesName && matchesType;
          }).toList();

          if (ideaBank.isEmpty) {
            return Center(
              child: Text("Press + to add a meal idea"),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView(
              children: filteredIdeas.map((i) {
                return MealIdeaTile(mealIdea: i, refresh: _onRefresh,);
              }).toList(),
            ),
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        heroTag: "foo1",
        onPressed: _goToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
