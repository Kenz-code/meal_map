import 'package:flutter/material.dart';
import 'package:meal_map/core/services/meal_idea_api_service.dart';
import 'package:meal_map/features/ideas/data/ideas_local_datasource.dart';
import 'package:meal_map/features/ideas/models/meal_idea.dart';

class AddIdeasPage extends StatefulWidget {
  const AddIdeasPage({super.key});

  @override
  State<AddIdeasPage> createState() => _AddIdeasPageState();
}

class _AddIdeasPageState extends State<AddIdeasPage> {
  final _formKey = GlobalKey<FormState>();

  String? manualIdea;
  String? prompt;
  String selectedType = "Breakfast";
  String person = "";

  List<String> generatedIdeas = [];

  Future<void> _saveManualIdea() async {
    if (manualIdea == null || manualIdea!.trim().isEmpty) return;
    if (person.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a person's name")),
      );
      return;
    }

    final idea = MealIdea(
      idea: manualIdea!.trim(),
      type: selectedType,
      person: person.trim(),
    );

    await IdeasLocalDatasource.saveMealIdea(idea);

    Navigator.pop(context); // go back to main page
  }

  Future<void> _generateIdeas() async {
    if (prompt == null || prompt!.isEmpty) return;

    final ideas = await MealIdeaApiService.getMealIdeas(prompt!);

    setState(() => generatedIdeas = ideas);
  }

  Future<void> _addGenerated(String idea) async {
    if (person.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter person's name to save ideas")),
      );
      return;
    }

    final newIdea = MealIdea(
      idea: idea,
      type: selectedType,
      person: person.trim(),
    );

    await IdeasLocalDatasource.saveMealIdea(newIdea);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saved!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Meal Ideas")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // ---------------- Person ----------------
            TextField(
              decoration: const InputDecoration(labelText: "Person's Name"),
              onChanged: (val) => person = val,
            ),

            const SizedBox(height: 8),

            DropdownButton<String>(
              value: selectedType,
              items: ["Breakfast", "Lunch", "Supper"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedType = val!),
            ),

            const Divider(),

            // ---------------- Manual Add ----------------
            const Text("Add Manual Idea",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              decoration: const InputDecoration(hintText: "Meal idea"),
              onChanged: (v) => manualIdea = v,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveManualIdea,
              child: const Text("Save Manual Idea"),
            ),

            const Divider(),

            // ---------------- AI Generator ----------------
            const Text("Generate with AI",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              decoration:
              const InputDecoration(hintText: "Prompt (ex: high protein)"),
              onChanged: (v) => prompt = v,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _generateIdeas,
              child: const Text("Generate Ideas"),
            ),

            const SizedBox(height: 16),

            if (generatedIdeas.isNotEmpty)
              const Text("Generated Ideas:",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),

            ...generatedIdeas.map((idea) {
              return Card(
                child: ListTile(
                  title: Text(idea),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _addGenerated(idea),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
