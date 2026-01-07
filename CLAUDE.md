# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
Peat Tracker - Ray Peat diet companion app for iOS with terminal occultism aesthetic.

**Stack**: Flutter + Dart, SQLite local storage, Open Food Facts API integration, Codemagic CI/CD

## Common Commands

### Development
- `flutter run` - Run app on connected device/emulator
- `flutter run -d chrome` - Run in Chrome browser
- `flutter pub get` - Install/update dependencies after modifying pubspec.yaml
- `flutter clean` - Clean build artifacts (run before pub get if having issues)

### Testing & Quality
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file
- `flutter analyze` - Run static analysis/linting

### Build
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS (requires Mac)
- iOS builds via Codemagic CI/CD on GitHub push

## Architecture

### Current State
The codebase is currently at initial Flutter boilerplate. Implementation follows the plan below.

### Planned Architecture

**Data Layer** - SQLite local storage with the following models:
- `Meal` - timestamp, categories, foods, notes
- `Food` - barcode, nutritional data, Ray Peat score + reasoning
- `Supplement` - name, dosage, time cluster, reminders
- `MetabolicMarker` - type, value, timestamp, lab name
- `JournalEntry` - text, tags, energy/digestion/sleep levels
- `CycleAlignment` - alignment score, influencing factors
- `CircadianSchedule` - wake/sleep times, optimal meal windows

**Services Layer**:
- `DatabaseService` - SQLite CRUD for all models
- `RayPeatScoringService` - Ray Peat diet scoring algorithm
  - PUFA penalty (polyunsaturated fats)
  - Carb/protein ratio rewards
  - Processing penalties
  - Blacklist checking
- `OpenFoodFactsService` - Barcode lookup via Open Food Facts API
- `RecommendationService` - Meal category recommendations based on underrepresented food groups
- `CircadianService` - Meal window calculations based on wake/sleep times

**UI Layer** - Provider for state management:
- Screens: home (4-tab nav), meal logging, barcode scanner, supplements, journal, trends
- Widgets: meal cards, Ray Peat score displays, recommendation chips, marker graphs, sigil visualizations

### Planned Dependencies

```yaml
sqflite: ^2.3.0        # Local database
path: ^1.8.3           # Path utilities
http: ^1.1.0           # HTTP client for API calls
image_picker: ^1.0.0   # Image selection
camera: ^0.10.0        # Camera access
google_ml_kit: ^0.13.0 # OCR for lab results
mobile_scanner: ^3.4.0 # Barcode scanning
provider: ^6.0.0       # State management
intl: ^0.19.0          # Internationalization
uuid: ^4.0.0           # UUID generation
fl_chart: ^0.65.0      # Charts for trend visualization
```

### Planned File Structure
```
lib/
  models/          # Data models (Meal, Food, Supplement, etc.)
  services/        # Business logic (Database, Scoring, API calls)
  screens/         # Full-page views (Home, Meal Logging, Scanner, etc.)
  widgets/         # Reusable UI components
  providers/       # State management
  theme/           # App theme and styling
  main.dart        # App entry point
```

## Design & Aesthetic

**Terminal Occultism Theme**:
- Dark mode primary: terminal blacks, deep purples, dark blues
- Accents: electric cyan, neon green highlights
- Typography: monospace for metrics, clean sans-serif for UI
- Iconography: sigils, moon phases, nodes/circles for data viz
- Animations: minimal and purposeful

## Domain-Specific Notes

**Ray Peat Diet Principles** (for scoring algorithm):
- Minimize PUFA (polyunsaturated fats) - primary penalty factor
- Favor carb-to-protein balance - rewards balanced ratios
- Penalize heavily processed foods
- Maintain blacklist of specific anti-Peat foods

**Open Food Facts API**:
- Free API with 2M+ products
- Returns macros, ingredients, processing level (NOVA score)
- Barcode format: EAN-13, UPC-A, UPC-E

**Feature Phases**:
1. Core: Meal logging, barcode scanning, Ray Peat scoring, recommendations
2. Timing: Circadian meal windows, metabolic marker tracking, trend graphs
3. Advanced: Supplement management, journal with correlations, cycle alignment

## CI/CD
- Codemagic configured for iOS builds
- GitHub push triggers automatic build
- TestFlight distribution configured