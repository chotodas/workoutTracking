class Workout {
  final int id;
  final String name;
  DateTime date;
  int value;
  bool isDone;

  Workout({
    required this.id,
    required this.name,
    required this.date,
    this.value = 0,
    this.isDone = false,
  });

  // Modify: Add JSON serialization method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'value': value,
      'isDone': isDone,
    };
  }

  // Modify: Add JSON deserialization factory method
  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
      value: json['value'],
      isDone: json['isDone'],
    );
  }
}
