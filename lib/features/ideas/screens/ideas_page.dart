import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/features/ideas/data/ideas_firestore_datasource.dart';
import 'package:meal_map/features/ideas/data/ideas_local_datasource.dart';
import 'package:meal_map/features/ideas/models/meal_idea.dart';
import 'package:meal_map/features/ideas/screens/add_ideas_page.dart';
import 'package:meal_map/features/ideas/widgets/meal_idea_tile.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  List<MealIdea> ideaBank = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBank();
  }

  Future<void> _loadBank() async {
    final bank = await IdeasFirestoreDatasource().loadMealIdeas();
    setState(() {
      ideaBank = bank;
      _isLoading = false;
    });
  }

  Future<void> _goToAddPage() async {
    await context.push('/ideas/create');
    await _loadBank(); // reload bank after adding ideas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Ideas"),
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return CircularProgressIndicator().center();
          }

          if (ideaBank.isEmpty) {
            return Center(
              child: Text("Press + to add a meal idea"),
            );
          }

          return ListView(
            children: ideaBank.map((i) {
              return MealIdeaTile(mealIdea: i,);
            }).toList(),
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
