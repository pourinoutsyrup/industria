import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'peat_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Meals table
    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        categories TEXT,
        notes TEXT
      )
    ''');

    // Foods table
    await db.execute('''
      CREATE TABLE foods (
        id TEXT PRIMARY KEY,
        barcode TEXT,
        name TEXT NOT NULL,
        calories REAL,
        protein REAL,
        carbs REAL,
        fat REAL,
        pufa REAL,
        nova_score INTEGER,
        ray_peat_score REAL NOT NULL,
        ray_peat_reasoning TEXT NOT NULL,
        added_at TEXT
      )
    ''');

    // Meal Foods junction table
    await db.execute('''
      CREATE TABLE meal_foods (
        meal_id TEXT NOT NULL,
        food_id TEXT NOT NULL,
        PRIMARY KEY (meal_id, food_id),
        FOREIGN KEY (meal_id) REFERENCES meals (id) ON DELETE CASCADE,
        FOREIGN KEY (food_id) REFERENCES foods (id) ON DELETE CASCADE
      )
    ''');

    // Supplements table
    await db.execute('''
      CREATE TABLE supplements (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        time_cluster TEXT NOT NULL,
        reminder_enabled INTEGER NOT NULL DEFAULT 0,
        reminder_time TEXT,
        days_of_week TEXT NOT NULL
      )
    ''');

    // Metabolic Markers table
    await db.execute('''
      CREATE TABLE metabolic_markers (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        value REAL NOT NULL,
        unit TEXT,
        timestamp TEXT NOT NULL,
        lab_name TEXT,
        notes TEXT
      )
    ''');

    // Journal Entries table
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        timestamp TEXT NOT NULL,
        text TEXT NOT NULL,
        tags TEXT,
        energy_level INTEGER,
        digestion_level INTEGER,
        sleep_quality INTEGER
      )
    ''');

    // Circadian Schedules table
    await db.execute('''
      CREATE TABLE circadian_schedules (
        id TEXT PRIMARY KEY,
        wake_time TEXT NOT NULL,
        sleep_time TEXT NOT NULL
      )
    ''');

    // Meal Windows table
    await db.execute('''
      CREATE TABLE meal_windows (
        id TEXT PRIMARY KEY,
        schedule_id TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        FOREIGN KEY (schedule_id) REFERENCES circadian_schedules (id) ON DELETE CASCADE
      )
    ''');
  }

  // MEALS
  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    await db.insert('meals', meal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // Insert meal-food relationships
    for (var food in meal.foods) {
      await db.insert('meal_foods', {
        'meal_id': meal.id,
        'food_id': food.id,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Meal>> getMeals({int? limit, DateTime? since}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (since != null) {
      whereClause = 'WHERE timestamp >= ?';
      whereArgs.add(since.toIso8601String());
    }

    final mealMaps = await db.query(
      'meals',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    final meals = <Meal>[];
    for (var mealMap in mealMaps) {
      final foods = await _getFoodsForMeal(mealMap['id'] as String);
      meals.add(Meal.fromMap(mealMap, foods));
    }

    return meals;
  }

  Future<List<Food>> _getFoodsForMeal(String mealId) async {
    final db = await database;
    final foodMaps = await db.rawQuery('''
      SELECT f.* FROM foods f
      INNER JOIN meal_foods mf ON f.id = mf.food_id
      WHERE mf.meal_id = ?
    ''', [mealId]);

    return foodMaps.map((map) => Food.fromMap(map)).toList();
  }

  Future<void> deleteMeal(String id) async {
    final db = await database;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  // FOODS
  Future<void> insertFood(Food food) async {
    final db = await database;
    await db.insert('foods', food.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Food?> getFoodByBarcode(String barcode) async {
    final db = await database;
    final maps = await db.query('foods', where: 'barcode = ?', whereArgs: [barcode], limit: 1);

    if (maps.isEmpty) return null;
    return Food.fromMap(maps.first);
  }

  Future<List<Food>> getAllFoods() async {
    final db = await database;
    final maps = await db.query('foods', orderBy: 'added_at DESC');
    return maps.map((map) => Food.fromMap(map)).toList();
  }

  Future<void> deleteFood(String id) async {
    final db = await database;
    await db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }

  // SUPPLEMENTS
  Future<void> insertSupplement(Supplement supplement) async {
    final db = await database;
    await db.insert('supplements', supplement.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Supplement>> getSupplements() async {
    final db = await database;
    final maps = await db.query('supplements', orderBy: 'name ASC');
    return maps.map((map) => Supplement.fromMap(map)).toList();
  }

  Future<void> updateSupplement(Supplement supplement) async {
    final db = await database;
    await db.update('supplements', supplement.toMap(), where: 'id = ?', whereArgs: [supplement.id]);
  }

  Future<void> deleteSupplement(String id) async {
    final db = await database;
    await db.delete('supplements', where: 'id = ?', whereArgs: [id]);
  }

  // METABOLIC MARKERS
  Future<void> insertMetabolicMarker(MetabolicMarker marker) async {
    final db = await database;
    await db.insert('metabolic_markers', marker.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<MetabolicMarker>> getMetabolicMarkers({String? type, DateTime? since}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (type != null && since != null) {
      whereClause = 'WHERE type = ? AND timestamp >= ?';
      whereArgs = [type, since.toIso8601String()];
    } else if (type != null) {
      whereClause = 'WHERE type = ?';
      whereArgs = [type];
    } else if (since != null) {
      whereClause = 'WHERE timestamp >= ?';
      whereArgs = [since.toIso8601String()];
    }

    final maps = await db.query(
      'metabolic_markers',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => MetabolicMarker.fromMap(map)).toList();
  }

  Future<void> deleteMetabolicMarker(String id) async {
    final db = await database;
    await db.delete('metabolic_markers', where: 'id = ?', whereArgs: [id]);
  }

  // JOURNAL ENTRIES
  Future<void> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    await db.insert('journal_entries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<JournalEntry>> getJournalEntries({int? limit, DateTime? since}) async {
    final db = await database;
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (since != null) {
      whereClause = 'WHERE timestamp >= ?';
      whereArgs = [since.toIso8601String()];
    }

    final maps = await db.query(
      'journal_entries',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map((map) => JournalEntry.fromMap(map)).toList();
  }

  Future<void> deleteJournalEntry(String id) async {
    final db = await database;
    await db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }

  // CIRCADIAN SCHEDULES
  Future<void> insertCircadianSchedule(CircadianSchedule schedule) async {
    final db = await database;
    await db.insert('circadian_schedules', schedule.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    // Insert meal windows
    for (var window in schedule.optimalMealWindows) {
      await db.insert('meal_windows', window.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<CircadianSchedule?> getLatestCircadianSchedule() async {
    final db = await database;
    final maps = await db.query('circadian_schedules', orderBy: 'wake_time DESC', limit: 1);

    if (maps.isEmpty) return null;

    final windows = await _getMealWindowsForSchedule(maps.first['id'] as String);
    return CircadianSchedule.fromMap(maps.first, windows);
  }

  Future<List<MealWindow>> _getMealWindowsForSchedule(String scheduleId) async {
    final db = await database;
    final maps = await db.query('meal_windows', where: 'schedule_id = ?', whereArgs: [scheduleId]);
    return maps.map((map) => MealWindow.fromMap(map)).toList();
  }

  Future<void> deleteCircadianSchedule(String id) async {
    final db = await database;
    await db.delete('circadian_schedules', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
