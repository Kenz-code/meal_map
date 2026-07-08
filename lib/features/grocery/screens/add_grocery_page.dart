import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/features/grocery/data/grocery_firestore_datasource.dart';
import 'package:meal_map/features/grocery/models/grocery_item.dart';
import 'package:meal_map/features/grocery/screens/grocery_page.dart';
import 'package:meal_map/features/grocery/services/previous_grocery_entry_handler.dart';

class AddGroceryPage extends StatefulWidget {
  const AddGroceryPage({super.key});

  @override
  State<AddGroceryPage> createState() => _AddGroceryPageState();
}

class _AddGroceryPageState extends State<AddGroceryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool isSaving = false;

  String _selectedCategory = 'Produce';

  final List<String> _categories = [
    'Produce',
    'Dairy',
    'Meat',
    'Bakery',
    'Beverages',
    'Pantry',
    'On Sale',
  ];

  void _submitItem() async {
    final navigator = Navigator.of(context);

    if (_formKey.currentState!.validate()) {
      toggleIsSaving();

      final newItem = GroceryItem(
        name: _nameController.text.trim(),
        category: _selectedCategory,
      );

      await GroceryFirestoreDatasource().saveGrocery(newItem);

      // add to previous entry handler
      PreviousGroceryEntryHandler.instance.addGroceryEntry(_nameController.text.trim());

      navigator.pop(newItem);
    }
  }

  void toggleIsSaving() {
    setState(() {
      isSaving = !isSaving;
    });
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
        title: Text('Add Grocery'),
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TypeAheadField<String>(
                    focusNode: FocusNode(),
                    controller: _nameController,
                    hideOnEmpty: true,
                    suggestionsCallback: (pattern) {
                      if (pattern.trim().isEmpty) {
                        return [];
                      }

                      final groceries =
                      PreviousGroceryEntryHandler.instance.loadPreviousGroceries();

                      return groceries.where(
                            (grocery) =>
                            grocery.toLowerCase().contains(pattern.toLowerCase()),
                      ).toList();
                    },
                    builder: (context, controller, focusNode) {
                      return TextFormField(
                        focusNode: focusNode,
                        controller: controller,
                        decoration: const InputDecoration(hintText: 'Item Name'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an item name';
                          }
                          return null;
                        },
                      );
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSelected: (suggestion) {
                      setState(() {
                        _nameController.text = suggestion;
                      });
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
                  ElevatedButton(
                    onPressed: !isSaving ? _submitItem : null,
                    child: Text('Add Item')
                  ).sizedWidth(double.infinity),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
