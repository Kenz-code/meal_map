class GroceryItem {
  final String id;        // <-- unique ID created once
  final String name;
  final String category;
  bool crossedOff;

  GroceryItem({
    required this.name,
    required this.category,
    this.crossedOff = false,
    String? id,                           // optional incoming ID
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();  // auto-generate if null

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'crossedOff': crossedOff,
    };
  }

  factory GroceryItem.fromMap(Map<String, dynamic> map) {
    return GroceryItem(
      id: map['id'],                       // restore ID from database/map
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      crossedOff: map['crossedOff'] ?? false,
    );
  }
}
