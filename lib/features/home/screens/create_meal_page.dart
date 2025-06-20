import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateMealPage extends StatefulWidget {
  const CreateMealPage({Key? key}) : super(key: key);

  @override
  State<CreateMealPage> createState() => _CreateMealPageState();
}

class _CreateMealPageState extends State<CreateMealPage> {
  final _formKey = GlobalKey<FormState>();

  String? _mealName;
  String? _mealType;
  String? _cook;
  String? _notes;
  DateTime _selectedDate = DateTime.now();

  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Replace this with your saving logic
      debugPrint('Meal Created:');
      debugPrint('Name: $_mealName');
      debugPrint('Type: $_mealType');
      debugPrint('Cook: $_cook');
      debugPrint('Date: $_selectedDate');
      debugPrint('Notes: $_notes');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal created!')),
      );

      context.pop(); // go_router
    }
  }

  Widget _buildFormContent() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text('Meal Name', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'e.g. Steak and Mashed Potatoes',
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a meal name' : null,
              onSaved: (value) => _mealName = value,
            ),
            const SizedBox(height: 24),

            Text('Meal Type', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _mealType,
              hint: const Text('Select meal type'),
              items: mealTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              validator: (value) => value == null ? 'Please select a meal type' : null,
              onChanged: (value) => setState(() => _mealType = value),
            ),
            const SizedBox(height: 24),

            Text('Cook', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            TextFormField(
              decoration: const InputDecoration(hintText: 'e.g. John Smith'),
              validator: (value) => value == null || value.isEmpty ? 'Please enter the cook\'s name' : null,
              onSaved: (value) => _cook = value,
            ),
            const SizedBox(height: 24),

            Text('Meal Date', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMM d, y').format(_selectedDate),
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text('Notes', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'e.g. Add extra garlic, prep night before...',
              ),
              maxLines: 3,
              onSaved: (value) => _notes = value,
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Meal')),
      body: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _buildFormContent(),
      ),
    );
  }
}
