import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

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

class _GroceryPageState extends State<GroceryPage> {
  final List<String> categories = [
    'Produce',
    'Dairy',
    'Meat',
    'Bakery',
    'Beverages',
    'Pantry',
  ];

  late Map<String, List<GroceryItem>> categoryItems;
  late List<GroceryItem> crossedOffItems;

  @override
  void initState() {
    super.initState();

    categoryItems = {
      'Produce': [
        GroceryItem(name: 'Apples', category: 'Produce'),
        GroceryItem(name: 'Bananas', category: 'Produce'),
        GroceryItem(name: 'Carrots', category: 'Produce'),
      ],
      'Dairy': [
        GroceryItem(name: 'Milk', category: 'Dairy'),
        GroceryItem(name: 'Cheese', category: 'Dairy'),
        GroceryItem(name: 'Yogurt', category: 'Dairy'),
      ],
      'Meat': [
        GroceryItem(name: 'Chicken Breast', category: 'Meat'),
        GroceryItem(name: 'Ground Beef', category: 'Meat'),
      ],
      'Bakery': [
        GroceryItem(name: 'Bread', category: 'Bakery'),
        GroceryItem(name: 'Bagels', category: 'Bakery'),
      ],
      'Beverages': [
        GroceryItem(name: 'Orange Juice', category: 'Beverages'),
        GroceryItem(name: 'Coffee', category: 'Beverages'),
      ],
      'Pantry': [
        GroceryItem(name: 'Rice', category: 'Pantry'),
        GroceryItem(name: 'Pasta', category: 'Pantry'),
        GroceryItem(name: 'Olive Oil', category: 'Pantry'),
      ],
    };

    crossedOffItems = [];
  }

  void _crossOffItem(GroceryItem item) {
    setState(() {
      categoryItems[item.category]!.remove(item);
      item.crossedOff = true;

      crossedOffItems.insert(0, item);

      if (crossedOffItems.length > 5) {
        crossedOffItems.removeLast();
      }
    });
  }

  Future<void> _restoreItem(GroceryItem item) async {
    final theme = Theme.of(context);
    final shouldRestore = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Restore Item',
          style: theme.textTheme.headlineSmall,
        ),
        content: Text(
          'Add "${item.name}" back to ${item.category}?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: theme.textTheme.labelLarge),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Restore', style: theme.textTheme.labelLarge),
          ),
        ],
      ),
    );

    if (shouldRestore == true) {
      setState(() {
        crossedOffItems.remove(item);
        item.crossedOff = false;
        categoryItems[item.category]!.add(item);
      });
    }
  }

  Widget _buildCategoryHeader(String category, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      color: theme.colorScheme.primary,
      child: Text(
        category,
        style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildCategorySection(String category, BuildContext context) {
    final theme = Theme.of(context);
    final items = categoryItems[category]!;

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(category, context),
          ...items.map(
                (item) => ListTile(
              title: Text(item.name, style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                icon: Icon(Icons.check_box_outline_blank, color: theme.iconTheme.color),
                onPressed: () => _crossOffItem(item),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossedOffSection(BuildContext context) {
    final theme = Theme.of(context);

    if (crossedOffItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 8),
          color: theme.colorScheme.primary.withOpacity(0.85),
          child: Text(
            'Crossed Off',
            style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ),
        ...crossedOffItems.map(
              (item) => ListTile(
            title: Text(
              item.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.undo, color: theme.colorScheme.onSurface.withOpacity(0.5)),
              onPressed: () => _restoreItem(item),
            ),
            onTap: () => _restoreItem(item),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => context.push('/grocery/create'),
        child: Icon(Icons.add_rounded),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...categories.map((cat) => _buildCategorySection(cat, context)),
            const SizedBox(height: 32),
            _buildCrossedOffSection(context),
          ],
        ),
      ),
    );
  }
}
