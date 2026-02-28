class MealIdea {
  final String idea;
  final String type;   // breakfast, lunch, supper
  final String person; // whose meal
  final String notes;
  final String id;

  MealIdea({
    required this.idea,
    required this.type,
    required this.person,
    required this.notes,
    String? id
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      "idea": idea,
      "type": type,
      "person": person,
      "notes": notes,
    };
  }

  factory MealIdea.fromMap(Map<String, dynamic> map) {
    return MealIdea(
      id: map['id'],
      idea: map["idea"],
      type: map["type"],
      person: map["person"],
      notes: map['notes'],
    );
  }
}
