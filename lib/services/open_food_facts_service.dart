import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'ray_peat_scoring_service.dart';
import 'package:uuid/uuid.dart';

class OpenFoodFactsService {
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v2';
  final uuid = const Uuid();

  /// Lookup product by barcode
  Future<Food?> lookupBarcode(String barcode) async {
    try {
      final url = Uri.parse('$baseUrl/product/$barcode');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(response.body);

      // Check if product was found
      if (data['status'] != 1) {
        return null;
      }

      final product = data['product'];
      if (product == null) {
        return null;
      }

      // Extract nutritional data (per 100g)
      final nutriments = product['nutriments'] ?? {};

      final name = product['product_name'] ?? 'Unknown Product';
      final calories = _parseDouble(nutriments['energy-kcal_100g']);
      final protein = _parseDouble(nutriments['proteins_100g']);
      final carbs = _parseDouble(nutriments['carbohydrates_100g']);
      final fat = _parseDouble(nutriments['fat_100g']);
      final saturatedFat = _parseDouble(nutriments['saturated-fat_100g']);

      // Calculate PUFA (estimate: total fat - saturated fat - monounsaturated fat)
      // If monounsaturated not available, estimate PUFA as 30% of (fat - saturated fat)
      final monoUnsaturatedFat = _parseDouble(nutriments['monounsaturated-fat_100g']);
      double? pufa;

      if (fat != null && saturatedFat != null) {
        if (monoUnsaturatedFat != null) {
          pufa = fat - saturatedFat - monoUnsaturatedFat;
          pufa = pufa.clamp(0, fat);
        } else {
          // Rough estimate
          pufa = (fat - saturatedFat) * 0.3;
        }
      }

      // Get NOVA score (processing level)
      final novaGroup = product['nova_group'];
      int? novaScore;
      if (novaGroup is int) {
        novaScore = novaGroup;
      } else if (novaGroup is String) {
        novaScore = int.tryParse(novaGroup);
      }

      // Get ingredients list
      final ingredientsText = product['ingredients_text'] as String?;

      // Calculate Ray Peat score
      final scoringResult = RayPeatScoringService.calculateScore(
        name: name,
        ingredients: ingredientsText,
        pufa: pufa,
        protein: protein,
        carbs: carbs,
        fat: fat,
        novaScore: novaScore,
      );

      return Food(
        id: uuid.v4(),
        barcode: barcode,
        name: name,
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        pufa: pufa,
        novaScore: novaScore,
        rayPeatScore: scoringResult.score,
        rayPeatReasoning: scoringResult.reasoning,
        addedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error looking up barcode: $e');
      return null;
    }
  }

  /// Search for products by name
  Future<List<ProductSearchResult>> searchProducts(String query) async {
    try {
      final url = Uri.parse('$baseUrl/search').replace(
        queryParameters: {
          'search_terms': query,
          'page_size': '20',
          'json': '1',
        },
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        return [];
      }

      final data = json.decode(response.body);
      final products = data['products'] as List? ?? [];

      return products.map((product) {
        return ProductSearchResult(
          barcode: product['code'] as String? ?? '',
          name: product['product_name'] as String? ?? 'Unknown',
          imageUrl: product['image_url'] as String?,
          brands: product['brands'] as String?,
        );
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

class ProductSearchResult {
  final String barcode;
  final String name;
  final String? imageUrl;
  final String? brands;

  ProductSearchResult({
    required this.barcode,
    required this.name,
    this.imageUrl,
    this.brands,
  });
}
