import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'models.dart';
import 'workout_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExerciseAdapter());

  // Open Box
  await Hive.openBox<Workout>(WorkoutProvider.boxName);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WorkoutProvider())],
      child: const XRepApp(),
    ),
  );
}

class XRepApp extends StatelessWidget {
  const XRepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xRep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF38BDF8),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF818CF8),
          surface: Color(0xFF1E293B),
        ),
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'xRep',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _selectedIndex == 0
          ? const WorkoutsPage()
          : const Center(child: Text('Profile Content')),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF38BDF8),
          unselectedItemColor: Colors.white54,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final Set<dynamic> _expandedKeys = {};

  void _showNewWorkoutDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('New Workout'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Workout Name (e.g. Leg Day)',
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
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final navigator = Navigator.of(context);
                final workout = await context
                    .read<WorkoutProvider>()
                    .addWorkout(controller.text);
                if (!mounted) return;
                setState(() {
                  _expandedKeys.add(workout.key);
                });
                navigator.pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = context.watch<WorkoutProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Workouts',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () => _showNewWorkoutDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add, size: 18, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 4),
                      Text(
                        'New',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF38BDF8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: workoutProvider.workouts.length,
              itemBuilder: (context, index) {
                final workout = workoutProvider.workouts[index];
                return WorkoutCard(
                  workoutIndex: index,
                  isExpanded: _expandedKeys.contains(workout.key),
                  onToggle: () {
                    setState(() {
                      if (_expandedKeys.contains(workout.key)) {
                        _expandedKeys.remove(workout.key);
                      } else {
                        _expandedKeys.add(workout.key);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
            hintText: 'Exercise Name (e.g. Bicep Curls)',
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
    final workout = context.watch<WorkoutProvider>().workouts[workoutIndex];
    final exercise = workout.exercises[exerciseIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
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
              child: _CircleButton(
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
              child: _CircleButton(
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
                    _CircleButton(
                      label: '-',
                      onTap: () => context.read<WorkoutProvider>().removeSet(
                        workoutIndex,
                        exerciseIndex,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _CircleButton(
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
            const SizedBox(height: 10),
            if (exercise.sets.isNotEmpty)
              SizedBox(
                height: 45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: exercise.sets.length,
                  itemBuilder: (context, setIndex) {
                    return RepBox(
                      workoutIndex: workoutIndex,
                      exerciseIndex: exerciseIndex,
                      setIndex: setIndex,
                      initialValue: exercise.sets[setIndex],
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

class _CircleButton extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final VoidCallback onTap;
  final Color? color;
  final Color? iconColor;

  const _CircleButton({
    this.icon,
    this.label,
    required this.onTap,
    this.color,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white10),
        ),
        child: icon != null
            ? IconTheme(
                data: IconThemeData(color: iconColor ?? Colors.white, size: 18),
                child: icon!,
              )
            : Text(
                label ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iconColor ?? const Color(0xFF38BDF8),
                ),
              ),
      ),
    );
  }
}

class RepBox extends StatefulWidget {
  final int workoutIndex;
  final int exerciseIndex;
  final int setIndex;
  final int initialValue;

  const RepBox({
    super.key,
    required this.workoutIndex,
    required this.exerciseIndex,
    required this.setIndex,
    required this.initialValue,
  });

  @override
  State<RepBox> createState() => _RepBoxState();
}

class _RepBoxState extends State<RepBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void didUpdateWidget(RepBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue.toString() != _controller.text) {
      _controller.text = widget.initialValue.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF38BDF8),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          final reps = int.tryParse(value) ?? 0;
          context.read<WorkoutProvider>().updateReps(
            widget.workoutIndex,
            widget.exerciseIndex,
            widget.setIndex,
            reps,
          );
        },
      ),
    );
  }
}
