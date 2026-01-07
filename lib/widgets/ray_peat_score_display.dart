import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/ray_peat_scoring_service.dart';

class RayPeatScoreDisplay extends StatelessWidget {
  final double score;
  final String reasoning;
  final bool compact;

  const RayPeatScoreDisplay({
    super.key,
    required this.score,
    required this.reasoning,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final scoreColor = AppTheme.getScoreColor(score);
    final recommendation = RayPeatScoringService.getRecommendation(score);

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scoreColor, width: 2),
            ),
            child: Text(
              score.toStringAsFixed(0),
              style: AppTheme.monoMetric.copyWith(
                color: scoreColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scoreColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scoreColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RAY PEAT SCORE',
                style: AppTheme.monoSmall.copyWith(
                  color: AppTheme.textGray,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: scoreColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  score.toStringAsFixed(0),
                  style: AppTheme.monoMetric.copyWith(
                    color: AppTheme.terminalBlack,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              recommendation.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'ANALYSIS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reasoning,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
