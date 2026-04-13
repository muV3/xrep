import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class WorkoutProvider with ChangeNotifier {
  static const String boxName = 'workouts_box';
  List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  WorkoutProvider() {
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final box = Hive.box<Workout>(boxName);
    _workouts = box.values.toList();
    notifyListeners();
  }

  Future<Workout> addWorkout(String name) async {
    final workout = Workout(name: name);
    final box = Hive.box<Workout>(boxName);
    await box.add(workout);
    _workouts.add(workout);
    notifyListeners();
    return workout;
  }

  Future<void> deleteWorkout(int index) async {
    final workout = _workouts[index];
    await workout.delete();
    _workouts.removeAt(index);
    notifyListeners();
  }

  Future<void> addExercise(int workoutIndex, String exerciseName) async {
    if (_workouts[workoutIndex].exercises.length >= 10) return;
    
    final exercise = Exercise(name: exerciseName, sets: []);
    _workouts[workoutIndex].exercises.add(exercise);
    await _workouts[workoutIndex].save();
    notifyListeners();
  }

  Future<void> removeExercise(int workoutIndex, int exerciseIndex) async {
    _workouts[workoutIndex].exercises.removeAt(exerciseIndex);
    await _workouts[workoutIndex].save();
    notifyListeners();
  }

  Future<void> addSet(int workoutIndex, int exerciseIndex) async {
    _workouts[workoutIndex].exercises[exerciseIndex].sets.add(0);
    await _workouts[workoutIndex].save();
    notifyListeners();
  }

  Future<void> removeSet(int workoutIndex, int exerciseIndex) async {
    if (_workouts[workoutIndex].exercises[exerciseIndex].sets.isNotEmpty) {
      _workouts[workoutIndex].exercises[exerciseIndex].sets.removeLast();
      await _workouts[workoutIndex].save();
      notifyListeners();
    }
  }

  Future<void> updateReps(int workoutIndex, int exerciseIndex, int setIndex, int reps) async {
    _workouts[workoutIndex].exercises[exerciseIndex].sets[setIndex] = reps;
    await _workouts[workoutIndex].save();
    notifyListeners();
  }

  Future<void> updateWorkoutName(int workoutIndex, String name) async {
     _workouts[workoutIndex].name = name;
     await _workouts[workoutIndex].save();
     notifyListeners();
  }
  
  Future<void> updateExerciseName(int workoutIndex, int exerciseIndex, String name) async {
    _workouts[workoutIndex].exercises[exerciseIndex].name = name;
    await _workouts[workoutIndex].save();
    notifyListeners();
  }
}
