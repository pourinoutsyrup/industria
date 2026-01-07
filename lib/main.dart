import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'providers/meal_provider.dart';
import 'providers/food_provider.dart';
import 'providers/supplement_provider.dart';

void main() {
  runApp(const PeatTrackerApp());
}

class PeatTrackerApp extends StatelessWidget {
  const PeatTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => SupplementProvider()),
      ],
      child: MaterialApp(
        title: 'Peat Tracker',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
