import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class MealProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Meal> _meals = [];
  bool _isLoading = false;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;

  Future<void> loadMeals({int? limit, DateTime? since}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _meals = await _db.getMeals(limit: limit, since: since);
    } catch (e) {
      print('Error loading meals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMeal(Meal meal) async {
    try {
      await _db.insertMeal(meal);
      await loadMeals();
    } catch (e) {
      print('Error adding meal: $e');
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      await _db.deleteMeal(id);
      _meals.removeWhere((meal) => meal.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting meal: $e');
    }
  }

  /// Get meal statistics for recommendations
  Map<String, int> getCategoryFrequency({int days = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final recentMeals = _meals.where((meal) => meal.timestamp.isAfter(cutoff)).toList();

    final frequency = <String, int>{};

    for (var meal in recentMeals) {
      meal.categories.forEach((category, checked) {
        if (checked) {
          frequency[category] = (frequency[category] ?? 0) + 1;
        }
      });
    }

    return frequency;
  }

  /// Get recommended categories (underrepresented ones)
  List<String> getRecommendations() {
    final allCategories = ['fruit', 'dairy', 'carbs', 'protein', 'salt', 'vegetables'];
    final frequency = getCategoryFrequency();

    // Find categories with low frequency
    final recommendations = <String>[];
    for (var category in allCategories) {
      final count = frequency[category] ?? 0;
      if (count < 2) {
        // Less than 2 times in last 7 days
        recommendations.add(category);
      }
    }

    return recommendations;
  }
}
