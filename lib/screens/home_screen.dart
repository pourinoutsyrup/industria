import 'package:flutter/material.dart';
import 'meal_logging_screen.dart';
import 'barcode_scanner_screen.dart';
import 'supplements_screen.dart';
import 'journal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MealLoggingScreen(),
    const BarcodeScannerScreen(),
    const SupplementsScreen(),
    const JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'MEALS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'SCAN',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'SUPPLEMENTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'JOURNAL',
          ),
        ],
      ),
    );
  }
}
