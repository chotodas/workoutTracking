import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_workout/presentation/providers/workout_provider.dart';
import 'workout_list_page.dart';
import 'chart_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    // Load workouts when the screen opens
    workoutProvider.loadInitialWorkouts();
  }

  // This function will refresh the state when coming back from another screen
  Future<void> _navigateToWorkoutList(BuildContext context) async {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    // Navigate to the WorkoutListPage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutListPage()),
    );

    // If result is true, reload the workouts when returning to this screen
    if (result == true) {
      // Reload workouts when the user returns
      setState(() {
        workoutProvider.loadInitialWorkouts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Tracker', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddWorkoutDialog(context, workoutProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                // Navigate to the Workout List and reload the HomePage when returning
                _navigateToWorkoutList(context);
              },
              child: Text(
                'Go to Workout List',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChartPage()),
                );
              },
              child: Text(
                'Go to Workout Chart',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: workoutProvider.filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = workoutProvider.filteredWorkouts[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workout.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Value: ${workout.value} | Done: ${workout.isDone ? 'Yes' : 'No'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  workoutProvider.markAsDone(workout.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: workout.isDone
                                      ? Colors.grey
                                      : Colors.blue,
                                ),
                                child: Text(
                                  workout.isDone ? 'Done' : 'Mark Done',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Slider(
                                value: workout.value.toDouble(),
                                min: 0,
                                max: 100,
                                divisions: 100,
                                label: workout.value.toString(),
                                onChanged: (value) {
                                  workoutProvider.setWorkoutValue(
                                      workout.id, value.toInt());
                                },
                                activeColor: Colors.blueAccent,
                                inactiveColor: Colors.grey[300],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWorkoutDialog(
      BuildContext context, WorkoutProvider workoutProvider) {
    final TextEditingController _nameController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Workout Name'),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Select Date:"),
                  TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        selectedDate = pickedDate;
                      }
                    },
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  workoutProvider.addWorkout(
                    _nameController.text,
                    selectedDate,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add Workout'),
            ),
          ],
        );
      },
    );
  }
}
