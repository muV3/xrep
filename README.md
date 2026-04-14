# xRep - Fitness Advancement Tracking

**xRep** is a premium, minimalist mobile fitness tracking application built with Flutter. It is designed to provide a high-performance, distraction-free environment for logging workouts, exercises, and sets.

## Purpose
The app aims to solve the problem of complex fitness trackers by offering a "set-first" approach. Users can quickly create workouts, add specific exercises, and track repetitions for every set. With built-in persistence, every rep is saved automatically, allowing users to focus entirely on their training.

## Features
- **Modern Dark UI**: A sleek, premium aesthetic designed for low-light gym environments.
- **Dynamic Workout Creation**: Effortlessly create and name your own workout routines.
- **Exercise Management**: Add up to 10 exercises per workout with individual set tracking.
- **Instant Persistence**: Powered by **Hive**, a lightweight and blazing-fast key-value database.
- **Premium Typography**: Uses the **Outfit** font for a clean, professional look.

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
