import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:practice_workout/presentation/providers/workout_provider.dart';

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPageState createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.black), // Custom icon for back button
          onPressed: () {
            // Action when back button is pressed (e.g., go back to the previous screen)
            Navigator.of(context).pop(true);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All Workouts'),
            Tab(text: 'By Date'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllWorkoutsTab(context, workoutProvider),
          _buildByDateTab(context, workoutProvider),
        ],
      ),
    );
  }

  // Widget for the "All Workouts" tab
  Widget _buildAllWorkoutsTab(
      BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: workoutProvider.workouts.length,
            itemBuilder: (context, index) {
              final workout = workoutProvider.workouts[index];
              return ListTile(
                title: Text(workout.name),
                subtitle: Text(
                    'Value: ${workout.value} | Done: ${workout.isDone ? 'Yes' : 'No'}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    workoutProvider.markAsDone(workout.id);
                  },
                  child: Text(workout.isDone ? 'Done' : 'Mark Done'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget for the "By Date" tab
  Widget _buildByDateTab(
      BuildContext context, WorkoutProvider workoutProvider) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              _selectDate(context, workoutProvider);
            },
            child: Text('Select Date to Filter Workouts'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: workoutProvider.filteredWorkouts.length,
            itemBuilder: (context, index) {
              final workout = workoutProvider.filteredWorkouts[index];
              return ListTile(
                title: Text(workout.name),
                subtitle: Text(
                    'Value: ${workout.value} | Done: ${workout.isDone ? 'Yes' : 'No'}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    workoutProvider.markAsDone(workout.id);
                  },
                  child: Text(workout.isDone ? 'Done' : 'Mark Done'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function to select a date and filter workouts by the selected date
  Future<void> _selectDate(
      BuildContext context, WorkoutProvider workoutProvider) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      workoutProvider.filterWorkoutsByDate(picked);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
