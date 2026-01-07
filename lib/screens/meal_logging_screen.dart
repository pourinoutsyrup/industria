import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/meal_provider.dart';
import '../models/models.dart';
import '../widgets/meal_card.dart';
import '../widgets/recommendation_chip.dart';

class MealLoggingScreen extends StatefulWidget {
  const MealLoggingScreen({super.key});

  @override
  State<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends State<MealLoggingScreen> {
  final uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealProvider>().loadMeals();
    });
  }

  void _showAddMealDialog() {
    final categories = {
      'fruit': false,
      'dairy': false,
      'carbs': false,
      'protein': false,
      'salt': false,
      'vegetables': false,
    };

    final selectedFoods = <Food>[];
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('LOG MEAL'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CATEGORIES', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: categories.keys.map((category) {
                    return FilterChip(
                      label: Text(category.toUpperCase()),
                      selected: categories[category]!,
                      onSelected: (selected) {
                        setState(() {
                          categories[category] = selected;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('NOTES', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    hintText: 'Add notes about this meal...',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                final meal = Meal(
                  id: uuid.v4(),
                  timestamp: DateTime.now(),
                  categories: categories,
                  foods: selectedFoods,
                  notes: notesController.text.isEmpty ? null : notesController.text,
                );

                context.read<MealProvider>().addMeal(meal);
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealProvider>();
    final recommendations = mealProvider.getRecommendations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('PEAT TRACKER'),
      ),
      body: Column(
        children: [
          if (recommendations.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RECOMMENDATIONS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: recommendations.map((category) {
                      return RecommendationChip(category: category);
                    }).toList(),
                  ),
                ],
              ),
            ),
          Expanded(
            child: mealProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : mealProvider.meals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No meals logged yet',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            const Text('Tap + to log your first meal'),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: mealProvider.meals.length,
                        itemBuilder: (context, index) {
                          final meal = mealProvider.meals[index];
                          return MealCard(
                            meal: meal,
                            onDelete: () {
                              mealProvider.deleteMeal(meal.id);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMealDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
