import 'dart:math';

import 'package:flutter/material.dart';
import 'package:practice_workout/data/models/workout_model.dart';
import 'package:practice_workout/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WorkoutProvider with ChangeNotifier {
  List<Workout> _workouts = [];
  List<Workout> _filteredWorkouts = [];

  List<Workout> get workouts => _workouts;
  List<Workout> get filteredWorkouts => _filteredWorkouts;

  // Modify: Initialize workouts by loading from SharedPreferences
  void loadInitialWorkouts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? workoutsString = prefs.getString('workouts');

    if (workoutsString != null) {
      List<dynamic> decodedWorkouts = jsonDecode(workoutsString);
      _workouts =
          decodedWorkouts.map((json) => Workout.fromJson(json)).toList();
    } else {
      _workouts = [
        Workout(id: 1, name: 'Push-ups', date: DateTime.now()),
        Workout(id: 2, name: 'Sit-ups', date: DateTime.now()),
        Workout(id: 3, name: 'Squats', date: DateTime.now()),
        Workout(id: 4, name: 'Plank', date: DateTime.now()),
      ];
    }

    _filteredWorkouts = _workouts;
    notifyListeners();
  }

  // Modify: Save workouts to SharedPreferences
  Future<void> _saveWorkoutsToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> workoutsJson =
        _workouts.map((workout) => workout.toJson()).toList();
    prefs.setString('workouts', jsonEncode(workoutsJson));
  }

  void addWorkout(String name, DateTime date) {
    final newWorkout = Workout(
      id: Random().nextInt(1000), // Generate a random ID for the workout
      name: name,
      date: date,
    );
    _workouts.add(newWorkout);
    _filteredWorkouts = _workouts; // Update the filtered list
    notifyListeners();
    _saveWorkoutsToPreferences(); // Save the updated workout list
  }

  // Modify: Mark workout as done and save changes
  void markAsDone(int workoutId) {
    final workout = _workouts.firstWhere((w) => w.id == workoutId);
    workout.isDone = true;
    notifyListeners();
    _saveWorkoutsToPreferences(); // Save to local storage
  }

  // Modify: Set the workout value and save changes
  void setWorkoutValue(int workoutId, int value) {
    final workout = _workouts.firstWhere((w) => w.id == workoutId);
    workout.value = value;
    notifyListeners();
    _saveWorkoutsToPreferences(); // Save to local storage
  }

  // Filter workouts by the selected date using the custom isSameDay method
  void filterWorkoutsByDate(DateTime date) {
    _filteredWorkouts = _workouts.where((w) => w.date.isSameDay(date)).toList();
    notifyListeners();
  }

  // Show all workouts without any date filtering
  void showAllWorkouts() {
    _filteredWorkouts = _workouts;
    notifyListeners();
  }

  // Modify: Reset all workouts and save changes
  void resetAllWorkouts() {
    for (var workout in _workouts) {
      workout.value = 0;
      workout.isDone = false;
    }
    notifyListeners();
    _saveWorkoutsToPreferences(); // Save to local storage
  }
}
