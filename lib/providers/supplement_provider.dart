import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class SupplementProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Supplement> _supplements = [];
  bool _isLoading = false;

  List<Supplement> get supplements => _supplements;
  bool get isLoading => _isLoading;

  Future<void> loadSupplements() async {
    _isLoading = true;
    notifyListeners();

    try {
      _supplements = await _db.getSupplements();
    } catch (e) {
      print('Error loading supplements: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSupplement(Supplement supplement) async {
    try {
      await _db.insertSupplement(supplement);
      await loadSupplements();
    } catch (e) {
      print('Error adding supplement: $e');
    }
  }

  Future<void> updateSupplement(Supplement supplement) async {
    try {
      await _db.updateSupplement(supplement);
      await loadSupplements();
    } catch (e) {
      print('Error updating supplement: $e');
    }
  }

  Future<void> deleteSupplement(String id) async {
    try {
      await _db.deleteSupplement(id);
      _supplements.removeWhere((supp) => supp.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting supplement: $e');
    }
  }

  /// Get supplements for a specific time cluster
  List<Supplement> getSupplementsForTime(String timeCluster) {
    return _supplements.where((s) => s.timeCluster == timeCluster).toList();
  }

  /// Get supplements due today
  List<Supplement> getSupplementsDueToday() {
    final today = DateTime.now().weekday;
    return _supplements.where((s) => s.daysOfWeek.contains(today)).toList();
  }
}
