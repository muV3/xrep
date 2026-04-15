import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Exercise> exercises;

  Workout({required this.name, List<Exercise>? exercises})
      : exercises = exercises ?? [];
}

@HiveType(typeId: 1)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<WorkoutSet> sets;

  Exercise({required this.name, List<WorkoutSet>? sets})
      : sets = sets ?? [];
}

@HiveType(typeId: 2)
class WorkoutSet extends HiveObject {
  @HiveField(0)
  int reps;

  @HiveField(1)
  double weight;

  WorkoutSet({this.reps = 0, this.weight = 0.0});
}

@HiveType(typeId: 3)
enum WeightUnit {
  @HiveField(0)
  kg,
  @HiveField(1)
  lb,
}
