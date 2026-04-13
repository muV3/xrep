import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xrep_app/models.dart';
import 'package:xrep_app/workout_provider.dart';
import 'dart:io';

void main() {
  test('WorkoutProvider logic test', () async {
    // Setup temporary Hive
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    await Hive.openBox<Workout>(WorkoutProvider.boxName);

    final provider = WorkoutProvider();
    
    // Test Add Workout
    await provider.addWorkout('Test Workout');
    expect(provider.workouts.length, 1);
    expect(provider.workouts[0].name, 'Test Workout');

    // Test Add Exercise
    await provider.addExercise(0, 'Test Exercise');
    expect(provider.workouts[0].exercises.length, 1);
    expect(provider.workouts[0].exercises[0].name, 'Test Exercise');

    // Test Add Set
    await provider.addSet(0, 0);
    expect(provider.workouts[0].exercises[0].sets.length, 1);
    expect(provider.workouts[0].exercises[0].sets[0], 0);

    // Test Update Reps
    await provider.updateReps(0, 0, 0, 10);
    expect(provider.workouts[0].exercises[0].sets[0], 10);

    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });
}
