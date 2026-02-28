import 'package:flutter/material.dart';
// Note: Assuming your imports for services and data remain correct.
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
  late FocusNode _promptTextFieldFocusNode;

  String? manualIdea;
  String? prompt;
  String selectedType = "Breakfast";
  String person = "";
  String notes = "";
  bool _isLoading = false; // New state for loading indicator

  List<String> generatedIdeas = [];

  @override
  void initState() {
    super.initState();
    _promptTextFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _promptTextFieldFocusNode.dispose();
    super.dispose();
  }

  // --- Utility Methods ---

  Future<void> _saveMealIdea(String idea) async {
    if (!_formKey.currentState!.validate()) {
      return; // Ensure the common fields (like person's name) are validated
    }

    final newIdea = MealIdea(
      idea: idea,
      type: selectedType,
      person: person.trim(),
      notes: notes.trim(),
    );

    await IdeasLocalDatasource.saveMealIdea(newIdea);
  }

  Future<void> _saveManualIdea() async {
    if (!_formKey.currentState!.validate()) return;
    if (manualIdea == null || manualIdea!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a meal idea")),
      );
      return;
    }

    await _saveMealIdea(manualIdea!);
    Navigator.pop(context); // Go back to main page
  }

  Future<void> _generateIdeas() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final ideas = await MealIdeaApiService.getMealIdeas(prompt!);
      setState(() => generatedIdeas = ideas);
    } catch (e) {
      // Handle error gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate ideas: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addGenerated(String idea) async {
    await _saveMealIdea(idea);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Saved!")));
  }

  // --- Widget Build ---

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: const Text("Add Meal Ideas"),
                  pinned: true,
                  bottom: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.edit), text: "Manual Idea"),
                      Tab(icon: Icon(Icons.rocket_launch), text: "AI Generator"),
                    ],
                  ),
                ),

                // 🔽 Shared content that scrolls with the tabs
                SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    child: _buildSharedFormFields(),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                // 👇 Manual tab (same State, scrollable)
                CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildManualInput(),
                    ),
                  ],
                ),

                // 👇 AI tab (setState works here)
                CustomScrollView(
                  shrinkWrap: true,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildAIGenerator(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSharedFormFields() {
    return Column(
      children: [
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: "Person's Name"),
          initialValue: person,
          onChanged: (val) => person = val,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter person's name";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: "Meal Type"),
          value: selectedType,
          items: ["Breakfast", "Lunch", "Supper"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => selectedType = val!),
        ),

        const SizedBox(height: 12),

        TextFormField(
          decoration: const InputDecoration(labelText: "Notes"),
          initialValue: notes,
          onChanged: (val) => notes = val,
          minLines: 2,
          maxLines: null,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildManualInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: "Enter meal idea (e.g., Chicken Stir-fry)",
            labelText: "Meal Idea",
          ),
          onChanged: (v) => manualIdea = v,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter meal idea";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveManualIdea,
          child: const Text("Save Manual Idea"),
        ),
      ],
    );
  }

  Widget _buildAIGenerator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          focusNode: _promptTextFieldFocusNode,
          decoration: const InputDecoration(
            hintText: "Example: high protein, easy to make",
            labelText: "AI Prompt",
          ),
          onChanged: (v) => prompt = v,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter a prompt";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _isLoading ? null : _generateIdeas,
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text("Generate Ideas"),
        ),
        const SizedBox(height: 16),
        if (generatedIdeas.isNotEmpty)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: const Text("Generated Ideas:",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              ...generatedIdeas.map((idea) {
                print(idea);

                return Card(
                  // Visually distinguish generated ideas
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(idea),
                    trailing: _AnimatedAddToCheck(
                      onAdd: () async {
                        await _addGenerated(idea);
                      },
                    ),
                  ),
                );
              }).toList(),
            ],
          )
      ],
    );
  }
}



class _AnimatedAddToCheck extends StatefulWidget {
  final Future<void> Function() onAdd;

  const _AnimatedAddToCheck({required this.onAdd});

  @override
  State<_AnimatedAddToCheck> createState() => _AnimatedAddToCheckState();
}

class _AnimatedAddToCheckState extends State<_AnimatedAddToCheck>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  bool _checked = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_checked) return;

    await widget.onAdd();
    setState(() => _checked = true);

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotation.value * 3.14159 * 2, // convert turns → radians
            child: Transform.scale(
              scale: _scale.value,
              child: Icon(
                _checked ? Icons.check_circle : Icons.add_circle,
                color: _checked ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
