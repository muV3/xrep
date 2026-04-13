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
  List<int> sets;

  Exercise({required this.name, List<int>? sets})
      : sets = sets ?? [];
}
