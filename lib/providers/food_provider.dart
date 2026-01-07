import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import '../services/open_food_facts_service.dart';

class FoodProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final OpenFoodFactsService _api = OpenFoodFactsService();

  List<Food> _foods = [];
  bool _isLoading = false;
  String? _error;

  List<Food> get foods => _foods;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFoods() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _foods = await _db.getAllFoods();
    } catch (e) {
      _error = 'Error loading foods: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Food?> lookupBarcode(String barcode) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if already in database
      Food? food = await _db.getFoodByBarcode(barcode);

      if (food != null) {
        _isLoading = false;
        notifyListeners();
        return food;
      }

      // Look up via API
      food = await _api.lookupBarcode(barcode);

      if (food != null) {
        // Save to database
        await _db.insertFood(food);
        await loadFoods();
      } else {
        _error = 'Product not found';
      }

      return food;
    } catch (e) {
      _error = 'Error looking up barcode: $e';
      print(_error);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ProductSearchResult>> searchProducts(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await _api.searchProducts(query);
      return results;
    } catch (e) {
      _error = 'Error searching products: $e';
      print(_error);
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFood(Food food) async {
    try {
      await _db.insertFood(food);
      await loadFoods();
    } catch (e) {
      _error = 'Error adding food: $e';
      print(_error);
      notifyListeners();
    }
  }

  Future<void> deleteFood(String id) async {
    try {
      await _db.deleteFood(id);
      _foods.removeWhere((food) => food.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Error deleting food: $e';
      print(_error);
    }
  }
}
