import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../models/models.dart';
import '../widgets/ray_peat_score_display.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;

  void _onBarcodeDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first.rawValue;
    if (barcode == null) return;

    setState(() {
      _isProcessing = true;
    });

    final foodProvider = context.read<FoodProvider>();
    final food = await foodProvider.lookupBarcode(barcode);

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
    });

    if (food != null) {
      _showFoodDetails(food);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(foodProvider.error ?? 'Product not found'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFoodDetails(Food food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              food.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            RayPeatScoreDisplay(
              score: food.rayPeatScore,
              reasoning: food.rayPeatReasoning,
            ),
            const SizedBox(height: 16),
            if (food.calories != null || food.protein != null || food.carbs != null || food.fat != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NUTRITION (per 100g)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (food.calories != null) Text('Calories: ${food.calories!.toStringAsFixed(0)} kcal'),
                  if (food.protein != null) Text('Protein: ${food.protein!.toStringAsFixed(1)}g'),
                  if (food.carbs != null) Text('Carbs: ${food.carbs!.toStringAsFixed(1)}g'),
                  if (food.fat != null) Text('Fat: ${food.fat!.toStringAsFixed(1)}g'),
                  if (food.pufa != null) Text('PUFA: ${food.pufa!.toStringAsFixed(1)}g'),
                ],
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BARCODE SCANNER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onBarcodeDetect,
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Point camera at barcode',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
