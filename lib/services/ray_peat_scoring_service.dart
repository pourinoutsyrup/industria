class RayPeatScoringService {
  // Ray Peat blacklist - foods to avoid
  static const List<String> blacklist = [
    'soybean',
    'soy',
    'canola',
    'rapeseed',
    'corn oil',
    'cottonseed',
    'safflower',
    'sunflower oil',
    'flaxseed',
    'fish oil',
    'pork',
    'bacon',
    'nuts',
    'seeds',
    'kale',
    'spinach',
    'chard',
    'beet greens',
  ];

  /// Calculate Ray Peat score for a food item
  /// Returns score from 0-100 and reasoning string
  static ScoringResult calculateScore({
    required String name,
    required String? ingredients,
    double? pufa,
    double? protein,
    double? carbs,
    double? fat,
    int? novaScore,
  }) {
    double score = 100.0; // Start with perfect score
    final reasons = <String>[];

    // 1. Blacklist check - heavy penalty
    final lowerName = name.toLowerCase();
    final lowerIngredients = ingredients?.toLowerCase() ?? '';

    for (var blacklisted in blacklist) {
      if (lowerName.contains(blacklisted) || lowerIngredients.contains(blacklisted)) {
        score -= 50;
        reasons.add('Contains blacklisted ingredient: $blacklisted');
        break; // Only apply once
      }
    }

    // 2. PUFA penalty - primary concern
    if (pufa != null && fat != null && fat > 0) {
      final pufaPercentage = (pufa / fat) * 100;

      if (pufaPercentage > 40) {
        score -= 40;
        reasons.add('Very high PUFA content (${pufaPercentage.toStringAsFixed(1)}% of fat)');
      } else if (pufaPercentage > 25) {
        score -= 25;
        reasons.add('High PUFA content (${pufaPercentage.toStringAsFixed(1)}% of fat)');
      } else if (pufaPercentage > 15) {
        score -= 15;
        reasons.add('Moderate PUFA content (${pufaPercentage.toStringAsFixed(1)}% of fat)');
      } else if (pufaPercentage < 5) {
        score += 10;
        reasons.add('Excellent low PUFA content');
      }
    }

    // 3. Carb to protein ratio - Ray Peat favors balanced ratios
    if (protein != null && carbs != null && protein > 0) {
      final carbProteinRatio = carbs / protein;

      if (carbProteinRatio >= 1.5 && carbProteinRatio <= 3.0) {
        score += 15;
        reasons.add('Good carb/protein balance (${carbProteinRatio.toStringAsFixed(1)}:1)');
      } else if (carbProteinRatio < 0.5) {
        score -= 10;
        reasons.add('Too protein-heavy, low carbs');
      } else if (carbProteinRatio > 5.0) {
        score -= 10;
        reasons.add('Too carb-heavy, low protein');
      }
    }

    // 4. Processing penalty (NOVA score)
    if (novaScore != null) {
      switch (novaScore) {
        case 1:
          score += 10;
          reasons.add('Unprocessed or minimally processed');
          break;
        case 2:
          score += 5;
          reasons.add('Processed culinary ingredient');
          break;
        case 3:
          score -= 15;
          reasons.add('Processed food');
          break;
        case 4:
          score -= 30;
          reasons.add('Ultra-processed food');
          break;
      }
    }

    // 5. Specific positive markers
    if (lowerName.contains('milk') ||
        lowerName.contains('cheese') ||
        lowerName.contains('yogurt')) {
      score += 5;
      reasons.add('Dairy product (Ray Peat approved)');
    }

    if (lowerName.contains('orange juice') ||
        lowerName.contains('fruit') && !lowerName.contains('dried')) {
      score += 5;
      reasons.add('Fresh fruit/juice (good sugar source)');
    }

    if (lowerName.contains('potato') ||
        lowerName.contains('rice') ||
        lowerName.contains('pasta')) {
      score += 5;
      reasons.add('Quality carb source');
    }

    if (lowerName.contains('gelatin') ||
        lowerName.contains('bone broth') ||
        lowerName.contains('collagen')) {
      score += 10;
      reasons.add('Gelatin/collagen (Ray Peat highly recommends)');
    }

    if (lowerName.contains('liver') ||
        lowerName.contains('oyster') ||
        lowerName.contains('shellfish')) {
      score += 10;
      reasons.add('Nutrient-dense animal product');
    }

    // Clamp score between 0 and 100
    score = score.clamp(0, 100);

    final reasoning = reasons.isEmpty ? 'No specific concerns or benefits identified' : reasons.join('; ');

    return ScoringResult(score: score, reasoning: reasoning);
  }

  /// Get recommendation level based on score
  static String getRecommendation(double score) {
    if (score >= 80) return 'Excellent - Ray Peat approved';
    if (score >= 60) return 'Good - Generally acceptable';
    if (score >= 40) return 'Fair - Use sparingly';
    if (score >= 20) return 'Poor - Not recommended';
    return 'Avoid - Against Ray Peat principles';
  }

  /// Get color code for score (for UI)
  static String getScoreColor(double score) {
    if (score >= 80) return 'green';
    if (score >= 60) return 'cyan';
    if (score >= 40) return 'yellow';
    if (score >= 20) return 'orange';
    return 'red';
  }
}

class ScoringResult {
  final double score;
  final String reasoning;

  ScoringResult({required this.score, required this.reasoning});
}
