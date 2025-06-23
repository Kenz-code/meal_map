import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroceryItem {
  final String name;
  final String category;
  bool crossedOff;

  GroceryItem({
    required this.name,
    required this.category,
    this.crossedOff = false,
  });
}

class AddGroceryPage extends StatefulWidget {
  const AddGroceryPage({super.key});

  @override
  State<AddGroceryPage> createState() => _AddGroceryPageState();
}

class _AddGroceryPageState extends State<AddGroceryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String _selectedCategory = 'Produce';

  final List<String> _categories = [
    'Produce',
    'Dairy',
    'Meat',
    'Bakery',
    'Beverages',
    'Pantry',
  ];

  void _submitItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = GroceryItem(
        name: _nameController.text.trim(),
        category: _selectedCategory,
      );
      Navigator.pop(context, newItem);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Grocery Item'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Item Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat, style: theme.textTheme.bodyLarge),
                ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Category',),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitItem,
                  child: Text('Add Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
