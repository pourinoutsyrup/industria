import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback? onDelete;

  const MealCard({
    super.key,
    required this.meal,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, y • h:mm a');
    final checkedCategories = meal.categories.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(meal.timestamp),
                  style: AppTheme.monoSmall.copyWith(
                    color: AppTheme.electricCyan,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (checkedCategories.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: checkedCategories.map((category) {
                  return Chip(
                    label: Text(
                      category.toUpperCase(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],
            if (meal.foods.isNotEmpty) ...[
              const Text(
                'FOODS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              ...meal.foods.map((food) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.getScoreColor(food.rayPeatScore),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          food.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        '${food.rayPeatScore.toStringAsFixed(0)}',
                        style: AppTheme.monoSmall.copyWith(
                          color: AppTheme.getScoreColor(food.rayPeatScore),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
            if (meal.notes != null && meal.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                meal.notes!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGray.withOpacity(0.8),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
