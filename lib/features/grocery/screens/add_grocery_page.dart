import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/features/grocery/screens/grocery_page.dart';

class AddGroceryPage extends StatefulWidget {
  const AddGroceryPage({super.key});

  @override
  State<AddGroceryPage> createState() => _AddGroceryPageState();
}

class _AddGroceryPageState extends State<AddGroceryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _selectedCategory;

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
        category: _selectedCategory!,
      );
      context.pop(newItem);
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
                initialValue: _selectedCategory,
                items: _categories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat, style: theme.textTheme.bodyLarge),
                        ))
                    .toList(),
                hint: Text("Select category"),
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
