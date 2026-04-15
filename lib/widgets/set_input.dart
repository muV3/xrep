import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../workout_provider.dart';
import '../models.dart';

class SetInput extends StatefulWidget {
  final int workoutIndex;
  final int exerciseIndex;
  final int setIndex;
  final WorkoutSet set;

  const SetInput({
    super.key,
    required this.workoutIndex,
    required this.exerciseIndex,
    required this.setIndex,
    required this.set,
  });

  @override
  State<SetInput> createState() => _SetInputState();
}

class _SetInputState extends State<SetInput> {
  late TextEditingController _repsController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _repsController = TextEditingController(text: widget.set.reps.toString());
    _weightController = TextEditingController(
      text: widget.set.weight == 0 ? '' : widget.set.weight.toString(),
    );
  }

  @override
  void didUpdateWidget(SetInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check reps: only update text if numerical value actually changed
    final currentReps = int.tryParse(_repsController.text) ?? 0;
    if (widget.set.reps != currentReps) {
      _repsController.text = widget.set.reps.toString();
    }

    // Check weight: only update text if numerical value actually changed
    final currentWeight = double.tryParse(_weightController.text) ?? 0.0;
    if (widget.set.weight != currentWeight) {
      _weightController.text = widget.set.weight == 0
          ? ''
          : widget.set.weight.toString();
    }
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final isOption3 = provider.useOption3;
    final unitLabel = provider.unit == WeightUnit.kg ? 'kg' : 'lb';

    if (isOption3) {
      return _buildOption3(unitLabel);
    } else {
      return _buildOption1(unitLabel);
    }
  }

  Widget _buildOption1(String unit) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildField(
            controller: _weightController,
            width: 38,
            hint: '0',
            color: const Color(0xFFF59E0B), // Amber
            onChanged: (v) => context.read<WorkoutProvider>().updateWeight(
              widget.workoutIndex,
              widget.exerciseIndex,
              widget.setIndex,
              double.tryParse(v) ?? 0.0,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFFF59E0B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(width: 1, height: 16, color: Colors.white12),
          const SizedBox(width: 2),
          _buildField(
            controller: _repsController,
            width: 36,
            hint: '0',
            color: const Color(0xFF38BDF8), // Cyan
            onChanged: (v) => context.read<WorkoutProvider>().updateReps(
              widget.workoutIndex,
              widget.exerciseIndex,
              widget.setIndex,
              int.tryParse(v) ?? 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption3(String unit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBadgeBox(
          controller: _weightController,
          label: unit,
          color: const Color(0xFF10B981), // Emerald
          width: 50,
          onChanged: (v) => context.read<WorkoutProvider>().updateWeight(
            widget.workoutIndex,
            widget.exerciseIndex,
            widget.setIndex,
            double.tryParse(v) ?? 0.0,
          ),
        ),
        _buildBadgeBox(
          controller: _repsController,
          label: 'reps',
          color: const Color(0xFF38BDF8), // Cyan
          width: 52,
          onChanged: (v) => context.read<WorkoutProvider>().updateReps(
            widget.workoutIndex,
            widget.exerciseIndex,
            widget.setIndex,
            int.tryParse(v) ?? 0,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBadgeBox({
    required TextEditingController controller,
    required String label,
    required Color color,
    required double width,
    required Function(String) onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isCollapsed: true,
              isDense: true,
              contentPadding: EdgeInsets.only(left: 3.20),
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: color.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required double width,
    required String hint,
    required Color color,
    required Function(String) onChanged,
  }) {
    return SizedBox(
      width: width,
      height: 35,
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            isCollapsed: true,
            contentPadding: const EdgeInsets.only(left: 3.25),
            hintText: hint,
            hintStyle: TextStyle(color: color.withValues(alpha: 0.3)),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
