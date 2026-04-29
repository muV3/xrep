# xRep - Fitness Advancement Tracking

**xRep** is a premium, minimalist mobile fitness tracking application built with Flutter. It is designed to provide a high-performance, distraction-free environment for logging workouts, exercises, and sets.

## Purpose
The app aims to provide an easy to use and visually appealing workout tracking environment. Users can create workouts, add exercises to created workouts and keep track of repetitions for every set.

## Features
- **Modern UI**: Easy to use and intuitive interface.
- **Dynamic Workout Creation**: Effortlessly create and name your own workouts.
- **Exercise Management**: Add up to 10 exercises per workout with individual set tracking.
- **Local Data Persistence**: Utilizes **Hive** to keep your data locally.

## How to Run the App

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version 3.27 or higher recommended)
- An Android Emulator, iOS Simulator, or a physical device.

### Setup and Running
1. **Clone or navigate to the project directory**:
   ```powershell
   cd <path>
   ```
2. **Fetch dependencies**:
   ```powershell
   flutter pub get
   ```
3. **Generate Hive TypeAdapters** (Required if changes are made to models):
   ```powershell
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Launch an emulator**:
   ```powershell
   flutter emulators --launch <emulator_id>
   ```
5. **Run the application**:
   ```powershell
   flutter run
   ```

## Codebase Overview

The project follows a modular structure focusing on separation of concerns:

- **`lib/models.dart`**: Contains the core data structures (`Workout`, `Exercise`). These classes are annotated with Hive tags for automatic serialization.
- **`lib/workout_provider.dart`**: The state management layer. It uses the `Provider` package to handle logic such as adding workouts, exercises, and sets, while simultaneously persisting data to the Hive box.
- **`lib/main.dart`**: The entry point of the app. It initializes Hive, registers type adapters, sets up the application theme, and builds the UI components.
- **`test/`**:
    - `provider_test.dart`: Unit tests for the `WorkoutProvider` to ensure logical correctness of the data operations.
    - `widget_test.dart`: Basic widget smoke tests.

## Technologies Used
- **Flutter & Dart**: Cross-platform UI development.
- **Hive**: Local persistence.
- **Provider**: State management.
- **Google Fonts (Outfit)**: Premium typography.
