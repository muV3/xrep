import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';

class WorkoutProvider with ChangeNotifier {
  static const String boxName = 'workouts_box';
  static const String settingsBoxName = 'settings_box';
  
  List<Workout> _workouts = [];
  WeightUnit _unit = WeightUnit.kg;
  bool _useOption3 = false;

  List<Workout> get workouts => _workouts;
  WeightUnit get unit => _unit;
  bool get useOption3 => _useOption3;

  WorkoutProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadSettings();
    await _loadWorkouts();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox(settingsBoxName);
    _unit = box.get('unit', defaultValue: WeightUnit.kg);
    _useOption3 = box.get('useOption3', defaultValue: false);
    notifyListeners();
  }

  Future<void> _loadWorkouts() async {
    final box = Hive.box<Workout>(boxName);
    _workouts = box.values.toList();
    notifyListeners();
  }

  Future<void> toggleUnit() async {
    final oldUnit = _unit;
    _unit = _unit == WeightUnit.kg ? WeightUnit.lb : WeightUnit.kg;

    // Convert all existing weights
    for (var workout in _workouts) {
      for (var exercise in workout.exercises) {
        for (var set in exercise.sets) {
          if (set.weight != 0) {
            if (oldUnit == WeightUnit.kg) {
              // KG to LB
              set.weight = double.parse((set.weight * 2.20462).toStringAsFixed(1));
            } else {
              // LB to KG
              set.weight = double.parse((set.weight / 2.20462).toStringAsFixed(1));
            }
          }
        }
      }
      await workout.save();
    }

    final box = await Hive.openBox(settingsBoxName);
    await box.put('unit', _unit);
    notifyListeners();
  }

  Future<void> toggleStyle() async {
    _useOption3 = !_useOption3;
    final box = await Hive.openBox(settingsBoxName);
    await box.put('useOption3', _useOption3);
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
    _workouts[workoutIndex].exercises[exerciseIndex].sets.add(WorkoutSet(reps: 0, weight: 0.0));
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
    _workouts[workoutIndex].exercises[exerciseIndex].sets[setIndex].reps = reps;
    await _workouts[workoutIndex].save();
    notifyListeners();
  }

  Future<void> updateWeight(int workoutIndex, int exerciseIndex, int setIndex, double weight) async {
    _workouts[workoutIndex].exercises[exerciseIndex].sets[setIndex].weight = weight;
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
