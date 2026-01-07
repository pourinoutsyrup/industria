class Meal {
  final String id;
  final DateTime timestamp;
  final Map<String, bool> categories; // fruit, dairy, carbs, protein, salt, etc.
  final List<Food> foods;
  final String? notes;

  Meal({
    required this.id,
    required this.timestamp,
    required this.categories,
    required this.foods,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'categories': categories.entries.map((e) => '${e.key}:${e.value}').join(','),
      'notes': notes,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map, List<Food> foods) {
    final categoriesStr = map['categories'] as String? ?? '';
    final categoriesMap = <String, bool>{};

    if (categoriesStr.isNotEmpty) {
      for (var entry in categoriesStr.split(',')) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          categoriesMap[parts[0]] = parts[1] == 'true';
        }
      }
    }

    return Meal(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      categories: categoriesMap,
      foods: foods,
      notes: map['notes'] as String?,
    );
  }
}

class Food {
  final String id;
  final String? barcode;
  final String name;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? pufa; // polyunsaturated fatty acids
  final int? novaScore; // processing level (1-4)
  final double rayPeatScore;
  final String rayPeatReasoning;
  final DateTime? addedAt;

  Food({
    required this.id,
    this.barcode,
    required this.name,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.pufa,
    this.novaScore,
    required this.rayPeatScore,
    required this.rayPeatReasoning,
    this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'pufa': pufa,
      'nova_score': novaScore,
      'ray_peat_score': rayPeatScore,
      'ray_peat_reasoning': rayPeatReasoning,
      'added_at': addedAt?.toIso8601String(),
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] as String,
      barcode: map['barcode'] as String?,
      name: map['name'] as String,
      calories: map['calories'] as double?,
      protein: map['protein'] as double?,
      carbs: map['carbs'] as double?,
      fat: map['fat'] as double?,
      pufa: map['pufa'] as double?,
      novaScore: map['nova_score'] as int?,
      rayPeatScore: map['ray_peat_score'] as double,
      rayPeatReasoning: map['ray_peat_reasoning'] as String,
      addedAt: map['added_at'] != null ? DateTime.parse(map['added_at'] as String) : null,
    );
  }
}

class Supplement {
  final String id;
  final String name;
  final String dosage;
  final String timeCluster; // morning, afternoon, evening, night
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final List<int> daysOfWeek; // 1-7, Monday to Sunday

  Supplement({
    required this.id,
    required this.name,
    required this.dosage,
    required this.timeCluster,
    this.reminderEnabled = false,
    this.reminderTime,
    this.daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time_cluster': timeCluster,
      'reminder_enabled': reminderEnabled ? 1 : 0,
      'reminder_time': reminderTime?.toIso8601String(),
      'days_of_week': daysOfWeek.join(','),
    };
  }

  factory Supplement.fromMap(Map<String, dynamic> map) {
    final daysStr = map['days_of_week'] as String? ?? '1,2,3,4,5,6,7';
    final days = daysStr.split(',').map((e) => int.parse(e)).toList();

    return Supplement(
      id: map['id'] as String,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      timeCluster: map['time_cluster'] as String,
      reminderEnabled: map['reminder_enabled'] == 1,
      reminderTime: map['reminder_time'] != null ? DateTime.parse(map['reminder_time'] as String) : null,
      daysOfWeek: days,
    );
  }
}

class MetabolicMarker {
  final String id;
  final String type; // TSH, T3, T4, glucose, etc.
  final double value;
  final String? unit;
  final DateTime timestamp;
  final String? labName;
  final String? notes;

  MetabolicMarker({
    required this.id,
    required this.type,
    required this.value,
    this.unit,
    required this.timestamp,
    this.labName,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'lab_name': labName,
      'notes': notes,
    };
  }

  factory MetabolicMarker.fromMap(Map<String, dynamic> map) {
    return MetabolicMarker(
      id: map['id'] as String,
      type: map['type'] as String,
      value: map['value'] as double,
      unit: map['unit'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
      labName: map['lab_name'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

class JournalEntry {
  final String id;
  final DateTime timestamp;
  final String text;
  final List<String> tags;
  final int? energyLevel; // 1-10
  final int? digestionLevel; // 1-10
  final int? sleepQuality; // 1-10

  JournalEntry({
    required this.id,
    required this.timestamp,
    required this.text,
    this.tags = const [],
    this.energyLevel,
    this.digestionLevel,
    this.sleepQuality,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'text': text,
      'tags': tags.join(','),
      'energy_level': energyLevel,
      'digestion_level': digestionLevel,
      'sleep_quality': sleepQuality,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    final tagsStr = map['tags'] as String? ?? '';
    final tags = tagsStr.isEmpty ? <String>[] : tagsStr.split(',');

    return JournalEntry(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      text: map['text'] as String,
      tags: tags,
      energyLevel: map['energy_level'] as int?,
      digestionLevel: map['digestion_level'] as int?,
      sleepQuality: map['sleep_quality'] as int?,
    );
  }
}

class CircadianSchedule {
  final String id;
  final DateTime wakeTime;
  final DateTime sleepTime;
  final List<MealWindow> optimalMealWindows;

  CircadianSchedule({
    required this.id,
    required this.wakeTime,
    required this.sleepTime,
    required this.optimalMealWindows,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wake_time': wakeTime.toIso8601String(),
      'sleep_time': sleepTime.toIso8601String(),
    };
  }

  factory CircadianSchedule.fromMap(Map<String, dynamic> map, List<MealWindow> windows) {
    return CircadianSchedule(
      id: map['id'] as String,
      wakeTime: DateTime.parse(map['wake_time'] as String),
      sleepTime: DateTime.parse(map['sleep_time'] as String),
      optimalMealWindows: windows,
    );
  }
}

class MealWindow {
  final String id;
  final String scheduleId;
  final DateTime startTime;
  final DateTime endTime;
  final String mealType; // breakfast, lunch, dinner, snack

  MealWindow({
    required this.id,
    required this.scheduleId,
    required this.startTime,
    required this.endTime,
    required this.mealType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'meal_type': mealType,
    };
  }

  factory MealWindow.fromMap(Map<String, dynamic> map) {
    return MealWindow(
      id: map['id'] as String,
      scheduleId: map['schedule_id'] as String,
      startTime: DateTime.parse(map['start_time'] as String),
      endTime: DateTime.parse(map['end_time'] as String),
      mealType: map['meal_type'] as String,
    );
  }
}
