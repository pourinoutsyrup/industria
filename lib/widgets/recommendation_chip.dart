import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RecommendationChip extends StatelessWidget {
  final String category;

  const RecommendationChip({
    super.key,
    required this.category,
  });

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruit':
        return Icons.apple;
      case 'dairy':
        return Icons.egg;
      case 'carbs':
        return Icons.rice_bowl;
      case 'protein':
        return Icons.lunch_dining;
      case 'salt':
        return Icons.grain;
      case 'vegetables':
        return Icons.spa;
      default:
        return Icons.food_bank;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.neonGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.neonGreen.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(category),
            size: 16,
            color: AppTheme.neonGreen,
          ),
          const SizedBox(width: 6),
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.neonGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
