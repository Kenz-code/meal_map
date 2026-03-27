import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_map/features/grocery/data/grocery_firestore_datasource.dart';
import 'package:meal_map/features/grocery/models/grocery_item.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage> {
  final List<String> categories = [
    'Produce',
    'Dairy',
    'Meat',
    'Bakery',
    'Beverages',
    'Pantry',
    'On Sale',
  ];

  late Future<Map<String, List<GroceryItem>>> _itemsFuture;
  List<GroceryItem> crossedOffItems = [];

  @override
  void initState() {
    super.initState();
    _itemsFuture = _fetchGroceryItems();
  }

  Future<Map<String, List<GroceryItem>>> _fetchGroceryItems() async {
    final allItems = await GroceryFirestoreDatasource().loadAllGroceries();

    final Map<String, List<GroceryItem>> categoryMap = {
      for (var c in categories) c: [],
    };

    final crossedOff = <GroceryItem>[];

    for (var item in allItems) {
      if (item.crossedOff) {
        crossedOff.add(item);
      } else {
        categoryMap[item.category]!.add(item);
      }
    }

    crossedOffItems = crossedOff;
    return categoryMap;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _itemsFuture = _fetchGroceryItems();
    });
  }

  void _crossOffItem(Map<String, List<GroceryItem>> items, GroceryItem item) {
    setState(() {
      items[item.category]!.remove(item);
      item.crossedOff = true;
      crossedOffItems.insert(0, item);
      if (crossedOffItems.length > 10) crossedOffItems.removeLast();
    });
    
    GroceryFirestoreDatasource().updateGroceryCrossedOff(item.id, item.crossedOff);
  }

  Future<void> _restoreItem(Map<String, List<GroceryItem>> items, GroceryItem item) async {
    final theme = Theme.of(context);
    final shouldRestore = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Item', style: theme.textTheme.headlineSmall),
        content: Text('Add "${item.name}" back to ${item.category}?', style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Restore')),
        ],
      ),
    );

    if (shouldRestore == true) {
      setState(() {
        crossedOffItems.remove(item);
        item.crossedOff = false;
        items[item.category]!.add(item);
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
      child: Text(category, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary)),
    );
  }

  Widget _buildCategorySection(Map<String, List<GroceryItem>> items, String category, BuildContext context) {
    final theme = Theme.of(context);
    final list = items[category] ?? [];
    if (list.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(category, context),
          ...list.map(
                (item) => ListTile(
              title: Text(item.name, style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                icon: const Icon(Icons.check_box_outline_blank),
                onPressed: () => _crossOffItem(items, item),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCrossedOffSection(Map<String, List<GroceryItem>> items, BuildContext context) {
    final theme = Theme.of(context);
    if (crossedOffItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isItemsMapEmpty(items) ? SizedBox.shrink() : Divider(thickness: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          margin: const EdgeInsets.only(bottom: 8),
          color: theme.colorScheme.primary.withOpacity(0.85),
          child: Text('Crossed Off', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onPrimary)),
        ),
        ...crossedOffItems.map(
              (item) => ListTile(
            dense: true,
            title: Text(
              item.name,
              style: theme.textTheme.bodyLarge?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.undo, color: theme.colorScheme.onSurface.withOpacity(0.5)),
              onPressed: () => _restoreItem(items, item),
            ),
            onTap: () => _restoreItem(items, item),
          ),
        ),
      ],
    );
  }

  void _navigateAndAddGrocery(Map<String, List<GroceryItem>> items) async {
    final GroceryItem? result = await context.push<GroceryItem?>('/grocery/create');
    if (result != null) {
      setState(() {
        _itemsFuture = _fetchGroceryItems();
      });
    }
  }

  bool _isItemsMapEmpty(Map<String, List<GroceryItem>> itemsMap) {
    final itemsList = itemsMap.values.toList();
    
    for (final item in itemsList) {
      if (item.isNotEmpty) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grocery List')),
      body: FutureBuilder<Map<String, List<GroceryItem>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading groceries: ${snapshot.error}'));
          } else if (!snapshot.hasData || (_isItemsMapEmpty(snapshot.data!) && crossedOffItems.isEmpty)) {
            return const Center(child: Text('No groceries found.'));
          }

          final items = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...categories.map((cat) => _buildCategorySection(items, cat, context)),
                      const SizedBox(height: 32),
                      _buildCrossedOffSection(items, context),
                    ],
                  ).constrainedHeight(min: constraints.maxHeight),
                );
              }
            ),
          );
        },
      ),
      floatingActionButton: FutureBuilder<Map<String, List<GroceryItem>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return FloatingActionButton(
            heroTag: "foo2",
            onPressed: () => _navigateAndAddGrocery(snapshot.data!),
            child: const Icon(Icons.add_rounded),
          );
        },
      ),
    );
  }
}
