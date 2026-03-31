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

  String getID() {
    final dateStr = '${dateTime.year}${dateTime.month.toString().padLeft(2, '0')}${dateTime.day.toString().padLeft(2, '0')}';
    return '${dateStr}_${mealType.toLowerCase()}';
  }

  // Compare all fields with another MealData instance (date only, no time)
  bool isEqualTo(MealData other) {
    return mealName == other.mealName &&
        mealType == other.mealType &&
        cook == other.cook &&
        notes == other.notes &&
        dateTime.year == other.dateTime.year &&
        dateTime.month == other.dateTime.month &&
        dateTime.day == other.dateTime.day;
  }

  // Print side-by-side comparison table for debugging
  void printComparison(MealData other) {
    print('\n${'=' * 80}');
    print('MealData Comparison');
    print('=' * 80);

    final thisDate = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final otherDate = '${other.dateTime.year}-${other.dateTime.month.toString().padLeft(2, '0')}-${other.dateTime.day.toString().padLeft(2, '0')}';
    final dateMatch = dateTime.year == other.dateTime.year &&
        dateTime.month == other.dateTime.month &&
        dateTime.day == other.dateTime.day;

    final rows = [
      ['Field', 'This', 'Other', 'Match'],
      ['-' * 15, '-' * 25, '-' * 25, '-' * 8],
      ['mealName', mealName, other.mealName, (mealName == other.mealName ? '✓' : '✗')],
      ['mealType', mealType, other.mealType, (mealType == other.mealType ? '✓' : '✗')],
      ['cook', cook, other.cook, (cook == other.cook ? '✓' : '✗')],
      ['notes', notes ?? 'null', other.notes ?? 'null', (notes == other.notes ? '✓' : '✗')],
      ['date (Y-M-D)', thisDate, otherDate, (dateMatch ? '✓' : '✗')],
    ];

    for (var row in rows) {
      print('${row[0].padRight(15)} | ${row[1].toString().padRight(25)} | ${row[2].toString().padRight(25)} | ${row[3]}');
    }

    print('=' * 80);
    print('Overall Match: ${isEqualTo(other) ? '✓ EQUAL' : '✗ NOT EQUAL'}');
    print('${'=' * 80}\n');
  }

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