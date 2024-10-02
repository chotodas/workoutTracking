import 'package:flutter/material.dart';
import 'package:practice_workout/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:practice_workout/presentation/providers/workout_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Workout Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(), // Use HomePage as the initial screen
      ),
    );
  }
}
