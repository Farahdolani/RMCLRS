import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ff/patiantscreen/home1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AngleStream {
  Stream<double> getAngleStream() {
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('all').child('roll');
    final StreamController<double> controller = StreamController<double>();

    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value as double?;
      if (data != null) {
        controller.add(data);
      }
    });

    return controller.stream;
  }
}

class Exercise extends StatefulWidget {
  final String exerciseName;
  static double plus = 0;

  const Exercise({Key? key, required this.exerciseName}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
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
  bool _timeUpMessageShown = false;
  int? _initialRepCount;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _listenToRepCount();
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

        if (_minutes == 5 && _completedReps > 0 && !_timeUpMessageShown) {
          _timeUpMessageShown = true;
          _showTimeUpMessage();
        }
      });
    });
  }

  void _showTimeUpMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Time's Up!"),
          content: Text("We will give you 2 minutes to finish the exercise."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateBackDelayed();
              },
            ),
          ],
        );
      },
    );
  }

   void _listenToRepCount() {
     final DatabaseReference databaseRef = FirebaseDatabase.instance.ref('repcount');
     databaseRef.onValue.listen((event) {
       final data = event.snapshot.value as int?;
       if (data != null) {
         setState(() {
           if (_initialRepCount == null) {
             // تخزين القيمة الأولية
             _initialRepCount = data;
           } else if (data > _initialRepCount!) {
             // التحقق من زيادة القيمة
             for (int i = 0; i < _completedSquares.length; i++) {
               if (!_completedSquares[i]) {
                 _completedSquares[i] = true;
                 _completedReps--;
                 vibrationoff();
                 if (_completedReps == 0) {
                   HomeScreen1.exe++;
                   Exercise.plus++;
                   print(HomeScreen1.exe);
                   updateProgressAtIndex();
                 }
                 break;
               }
             }
             _initialRepCount = data;  // تحديث القيمة الأولية بعد التغيير
           }
         });
       }
     });
   }
  void updateProgressAtIndex() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference patientRef = FirebaseFirestore.instance.collection('patient2').doc(user?.uid);
    DocumentSnapshot snapshot = await patientRef.get();
    List<dynamic> progressArray = snapshot['progress'];
    progressArray[1] = HomeScreen1.exe;
    progressArray[2] = HomeScreen1.exe * 12.5;
    await patientRef.update({'progress': progressArray});
  }

  void _stopExercise() {
    _timer.cancel();
    setState(() {
      _exerciseStopped = true;
    });
  }

  void _resumeExercise() {
    _startTimer();
    setState(() {
      _exerciseStopped = false;
    });
  }

  void _navigateBack() {
    Navigator.pop(context);
    endEx();
  }

  void _navigateBackDelayed() {
    Future.delayed(Duration(minutes: 2), () {
      if (_completedReps > 0) {
        _navigateBack();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _stopExercise();
            _navigateBack();
          },
        ),
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
                foregroundColor: Colors.white,
                backgroundColor: _exerciseStopped ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> endEx() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('start1');
      DatabaseReference ref2 = FirebaseDatabase.instance.ref('start');
      await ref.set(false);
      await ref2.set(false);
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<void> vibrationoff() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('vibration');
      await ref.set(true);
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<void> vibration() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('vibration');
      await ref.set(false);
    } catch (e) {
      print('Error : $e');
    }
  }
}