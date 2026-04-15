import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';
import 'exercise_tile.dart';

class WorkoutCard extends StatelessWidget {
  final int workoutIndex;
  final bool isExpanded;
  final VoidCallback onToggle;

  const WorkoutCard({
    super.key,
    required this.workoutIndex,
    required this.isExpanded,
    required this.onToggle,
  });

  void _showAddExerciseDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Exercise'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Exercise Name',
            hintStyle: TextStyle(color: Colors.white54),
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
                context.read<WorkoutProvider>().addExercise(
                  workoutIndex,
                  controller.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = context.watch<WorkoutProvider>().workouts[workoutIndex];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workout.name,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF38BDF8),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const Divider(color: Colors.white10, height: 20),
            ...workout.exercises.asMap().entries.map((entry) {
              return ExerciseTile(
                workoutIndex: workoutIndex,
                exerciseIndex: entry.key,
              );
            }),
            if (workout.exercises.length < 10)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton.icon(
                  onPressed: () => _showAddExerciseDialog(context),
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text('Add Exercise'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF38BDF8),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
