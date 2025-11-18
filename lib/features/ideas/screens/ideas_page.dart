import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/features/ideas/data/ideas_local_datasource.dart';
import 'package:meal_map/features/ideas/models/meal_idea.dart';
import 'package:meal_map/features/ideas/screens/add_ideas_page.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  List<MealIdea> ideaBank = [];

  @override
  void initState() {
    super.initState();
    _loadBank();
  }

  Future<void> _loadBank() async {
    final bank = await IdeasLocalDatasource.loadMealIdeas();
    setState(() => ideaBank = bank);
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
          if (ideaBank.isEmpty) {
            return Center(
              child: Text("Press + to add a meal idea"),
            );
          }

          return ListView(
            children: ideaBank.map((i) {
              return ListTile(
                title: Text(i.idea),
                subtitle: Text("${i.type} • ${i.person}"),
              );
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
