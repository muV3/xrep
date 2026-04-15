import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';
import 'common/circle_button.dart';
import 'set_input.dart';

class ExerciseTile extends StatelessWidget {
  final int workoutIndex;
  final int exerciseIndex;

  const ExerciseTile({
    super.key,
    required this.workoutIndex,
    required this.exerciseIndex,
  });

  void _showEditExerciseDialog(BuildContext context, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Edit Exercise'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Exercise Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<WorkoutProvider>().updateExerciseName(
                  workoutIndex,
                  exerciseIndex,
                  controller.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final workout = provider.workouts[workoutIndex];
    final exercise = workout.exercises[exerciseIndex];
    final isOption3 = provider.useOption3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        key: ValueKey(exercise.hashCode),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.22,
          children: [
            CustomSlidableAction(
              onPressed: (context) =>
                  _showEditExerciseDialog(context, exercise.name),
              backgroundColor: Colors.transparent,
              alignment: Alignment.topCenter,
              child: CircleButton(
                icon: const Icon(Icons.edit_rounded),
                iconColor: Colors.white,
                color: Colors.amber,
                onTap: () => _showEditExerciseDialog(context, exercise.name),
              ),
            ),
            CustomSlidableAction(
              onPressed: (context) => context
                  .read<WorkoutProvider>()
                  .removeExercise(workoutIndex, exerciseIndex),
              backgroundColor: Colors.transparent,
              alignment: Alignment.topCenter,
              child: CircleButton(
                icon: const Icon(Icons.delete_outline_rounded),
                iconColor: Colors.white,
                color: Colors.redAccent,
                onTap: () => context.read<WorkoutProvider>().removeExercise(
                  workoutIndex,
                  exerciseIndex,
                ),
              ),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleButton(
                      label: '-',
                      onTap: () => context.read<WorkoutProvider>().removeSet(
                        workoutIndex,
                        exerciseIndex,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleButton(
                      label: '+',
                      onTap: () => context.read<WorkoutProvider>().addSet(
                        workoutIndex,
                        exerciseIndex,
                      ),
                    ),
                    const SizedBox(width: 8), // Gap before the slider buttons
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (exercise.sets.isNotEmpty)
              SizedBox(
                height: isOption3 ? 55 : 40,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: exercise.sets.length,
                  itemBuilder: (context, setIndex) {
                    return SetInput(
                      workoutIndex: workoutIndex,
                      exerciseIndex: exerciseIndex,
                      setIndex: setIndex,
                      set: exercise.sets[setIndex],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
