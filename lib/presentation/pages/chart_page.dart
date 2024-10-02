// presentation/screens/chart_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_workout/presentation/providers/workout_provider.dart';

class ChartPage extends StatefulWidget {
  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller to animate the chart bars
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Workout Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: workoutProvider.workouts.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Workout Values (0 to 100)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: workoutProvider.workouts.map((workout) {
                        // Each workout's value is visualized as a bar in the chart
                        return AnimatedBar(
                          value: workout.value,
                          controller: _controller,
                          label: workout.name, // Label for each bar
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            : Center(
                // Show a message when no workouts are available
                child: Text(
                  'No workout data available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

// A simple animated bar widget that represents each workout
class AnimatedBar extends StatelessWidget {
  final int value;
  final AnimationController? controller;
  final String label;

  AnimatedBar(
      {required this.value, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: controller!,
          builder: (context, child) {
            // Animate the height of the bar based on the workout value
            return Container(
              width: 30,
              height:
                  200 * (controller!.value * (value / 100)), // Dynamic height
              color: Colors.blue,
              alignment: Alignment.bottomCenter,
            );
          },
        ),
        SizedBox(height: 8), // Spacing between the bar and the label
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
