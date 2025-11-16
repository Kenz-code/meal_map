class MealIdea {
  final String idea;
  final String type;   // breakfast, lunch, supper
  final String person; // whose meal

  MealIdea({
    required this.idea,
    required this.type,
    required this.person,
  });

  Map<String, dynamic> toMap() {
    return {
      "idea": idea,
      "type": type,
      "person": person,
    };
  }

  factory MealIdea.fromMap(Map<String, dynamic> map) {
    return MealIdea(
      idea: map["idea"],
      type: map["type"],
      person: map["person"],
    );
  }
}
