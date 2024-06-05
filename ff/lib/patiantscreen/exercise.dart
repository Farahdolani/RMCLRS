import 'package:flutter/material.dart';
import 'dart:async';

import 'package:ff/patiantscreen/angle.dart';

class Exercise extends StatefulWidget {
  final String exerciseName;

  const Exercise({Key? key, required this.exerciseName}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();

  // Static variable to track the repetitions
  static double exe = 0;
  
}

class _ExerciseState extends State<Exercise> {
  late Timer _timer;
  int _seconds = 0;
  int _minutes = 0;
  int _hours = 0;
  int _completedReps = 15;
  List<bool> _completedSquares = List.generate(15, (index) => false);
  bool _exerciseStopped = false;
  bool _exercisePaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (!_exerciseStopped && !_exercisePaused) {
          _seconds++;
          if (_seconds == 60) {
            _seconds = 0;
            _minutes++;
            if (_minutes == 60) {
              _minutes = 0;
              _hours++;
            }
          }
        }
      });
    });
  }

  void _stopExercise() {
    _timer.cancel();
    setState(() {
      _exerciseStopped = true;
    });
    // Save exercise data here
    // Reset variables if needed
  }

  void _resumeExercise() {
    _startTimer();
    setState(() {
      _exerciseStopped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.exerciseName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${_hours.toString().padLeft(2, '0')}:${_minutes.toString().padLeft(2, '0')}:${_seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder<double>(
              stream: AngleStream().getAngleStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final angle = snapshot.data!;
                if (!_exerciseStopped && angle >= 60 && _completedReps > 0) {
                  for (int i = 0; i < _completedSquares.length; i++) {
                    if (_completedSquares[i] == false) {
                      _completedSquares[i] = true;
                      _completedReps--;
                      if (_completedReps == 0) {
                        Exercise.exe++; // Increment the global variable
                        print(Exercise.exe);
                      }
                      break; // Break after coloring one square
                    }
                  }
                }

                return CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    angle.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                15,
                (index) => Container(
                  width: 15,
                  height: 15,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _completedSquares[index] ? Colors.green : Colors.grey,
                    border: Border.all(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              color: Colors.purple,
              padding: EdgeInsets.all(10),
              child: Text(
                'Rep: $_completedReps',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_exerciseStopped) {
                  _resumeExercise();
                } else {
                  _stopExercise();
                }
              },
              child: Text(
                _exerciseStopped ? 'Resume Exercise' : 'Emergency Stop',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: _exerciseStopped ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
