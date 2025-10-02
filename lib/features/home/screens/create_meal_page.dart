import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meal_map/features/home/data/meals_firestore_datasource.dart';
import 'package:meal_map/features/home/data/meals_local_datasource.dart';
import 'package:meal_map/features/home/models/meal_data.dart';

class CreateMealPage extends StatefulWidget {
  const CreateMealPage({super.key, required this.firstAndLastDays});

  final List<DateTime> firstAndLastDays;

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

  DateTime? firstDay;
  DateTime? lastDay;

  bool saving = false;

  final List<String> mealTypes = ['Breakfast', 'Lunch', 'Dinner'];

  Future<bool> checkForOverridingMeals(DateTime date, String mealType) async {
    bool isThereOverridingMeals = false;

    final allMeals = await MealsLocalDatasource.loadAllMeals();

    for (final meal in allMeals) {
      if (meal.dateTime.year == date.year &&
          meal.dateTime.month == date.month &&
          meal.dateTime.day == date.day &&
          meal.mealType == mealType
      ) {
        isThereOverridingMeals = true;
      }
    }

    return isThereOverridingMeals;
  }

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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _selectedDate = DateTime(
          _selectedDate.year, _selectedDate.month, _selectedDate.day, 12, 0, DateTime.now().millisecond);

      bool okToSave = true;
      // check if selectedDate is before firstDay or after lastDay and conform with user
      if (_selectedDate.isBefore(widget.firstAndLastDays[0])) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Date out of range"),
                  content: Text(
                      "The selected date is from a past week and won't appear on the Meals Screen."),
                  actions: [
                    TextButton(
                      child: Text("Back"),
                      onPressed: () {
                        okToSave = false;
                        context.pop();
                      },
                    ),
                    TextButton(
                      child: Text("Save"),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ));
      } else if (_selectedDate.isAfter(widget.firstAndLastDays[1])) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Date out of range"),
                  content: Text(
                      "The selected date is too far in the future and won't appear on the Meals Screen until it's within 3 weeks."),
                  actions: [
                    TextButton(
                      child: Text("Back"),
                      onPressed: () {
                        okToSave = false;
                        context.pop();
                      },
                    ),
                    TextButton(
                      child: Text("Save"),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ],
                ));
      }

      setState(() {
        saving = true;
      });

      await checkForOverridingMeals(_selectedDate, _mealType!).then(
              (isThereOverridingMeals) {
                if (isThereOverridingMeals) {
                  okToSave = false;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        "You can't override existing meals!",
                        style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Theme.of(context).colorScheme.onError),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              }
      );

      final MealData mealData = MealData(
          mealName: _mealName!,
          mealType: _mealType!,
          cook: _cook!,
          notes: _notes,
          dateTime: _selectedDate);

      if (okToSave) {
        await MealsFirestoreDatasource().saveMeal(mealData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal created!')),
        );

        context.pop();
      } else {
        setState(() {
          saving = false;
        });
      }
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
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a meal name'
                  : null,
              onSaved: (value) => _mealName = value,
            ),
            const SizedBox(height: 24),
            Text('Meal Type', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              initialValue: _mealType,
              hint: const Text('Select meal type'),
              items: mealTypes
                  .map((type) =>
                      DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              validator: (value) =>
                  value == null ? 'Please select a meal type' : null,
              onChanged: (value) => setState(() => _mealType = value),
            ),
            const SizedBox(height: 24),
            Text('Cook', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            TextFormField(
              decoration: const InputDecoration(hintText: 'e.g. John Smith'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter the cook\'s name'
                  : null,
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
              onPressed: !saving ? _submitForm : null,
              child: !saving
                  ? const Text('Save Meal')
                  : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircularProgressIndicator(),
                  ),
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
