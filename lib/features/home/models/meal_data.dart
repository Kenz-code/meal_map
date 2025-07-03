class MealData {
  String mealName;
  String mealType;
  String cook;
  String? notes;
  DateTime dateTime;

  MealData({
    required this.mealName,
    required this.mealType,
    required this.cook,
    required this.notes,
    required this.dateTime,
  });

  // Convert a MealData instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'mealName': mealName,
      'mealType': mealType,
      'cook': cook,
      'notes': notes,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create a MealData instance from a Map
  factory MealData.fromMap(Map<String, dynamic> map) {
    return MealData(
      mealName: map['mealName'] ?? '',
      mealType: map['mealType'] ?? '',
      cook: map['cook'] ?? '',
      notes: map['notes'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  String getID() => dateTime.millisecondsSinceEpoch.toString();

  @override
  String toString() {
    return 'MealData('
        'mealName: $mealName, '
        'mealType: $mealType, '
        'cook: $cook, '
        'notes: ${notes ?? "none"}, '
        'dateTime: $dateTime'
        ')';
  }
}
