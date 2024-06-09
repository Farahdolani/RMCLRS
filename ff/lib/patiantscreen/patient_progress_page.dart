import 'package:ff/patiantscreen/exercise.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:ff/patiantscreen/pat_generate_report.dart';
import 'package:ff/patiantscreen/report_ph2.dart';
import 'package:flutter/material.dart';
import 'package:ff/therapisto/doctor_plist.dart';
import 'package:ff/patiantscreen/exercise_learn.dart';
import 'package:ff/patiantscreen/exercise_learn2.dart';
import 'package:ff/therapisto/generate_report.dart';
import 'package:ff/therapisto/send_feedback.dart';
import 'package:ff/welcome_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User1 extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User1> {
  // Placeholder values for the progress
  double phasesProgress = HomeScreen1.exe / 2;
  double exercisesProgress = HomeScreen1.exe;
  double overallProgress = HomeScreen1.exe * 12.5;

  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchAndUpdateProgress();
  }

  Future<void> fetchAndUpdateProgress() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is signed in.");
        return;
      }

      // Get a reference to the patient document
      DocumentReference patientRef =
          FirebaseFirestore.instance.collection('patient2').doc(user.uid);

      // Fetch the current document snapshot
      DocumentSnapshot snapshot = await patientRef.get();

      if (snapshot.exists) {
        // Get the current progress array
        List<dynamic> progressArray = snapshot['progress'];

        // Store the value at the specified index in HomeScreen1.exe

        HomeScreen1.exe = progressArray[1];
        setState(() {});

        print("Fetched progress: ${HomeScreen1.exe}");
      } else {
        print("Patient document does not exist");
      }
    } catch (e) {
      print("Failed to fetch and update progress: $e");
    }
  }

  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('patient2')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            userName = userDoc.data()?['name'] ?? "Unknown User";
          });
        } else {
          setState(() {
            userName = "User not found";
          });
        }
      }
    } catch (e) {
      setState(() {
        userName = "Error loading user";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen1()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Set background color to gray
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey, // Placeholder color for the profile photo
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: const Color.fromARGB(255, 168, 130, 130),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    userName,
                    style: TextStyle(fontSize: 22, color: Colors.purple),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Phases',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Placeholder circular progress indicator with value displayed
            _buildCircularElement(1),
            Text(
              'Exercises',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Placeholder circular progress indicator with value displayed
            _buildCircularElement(HomeScreen1.exe),
            Text(
              'Overall Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Placeholder circular progress indicator with value displayed as percentage
            _buildCircularElement(HomeScreen1.exe * 12.5, showPercentage: true),
            // Add some space between progress and buttons
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity, // Full width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Repophase2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Set button color to purple
                ),
                child: Text(
                  'Generate a report',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularElement(double progressValue,
      {bool showPercentage = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
        ),
        Text(
          showPercentage
              ? '${progressValue.toStringAsFixed(2)}%'
              : '${progressValue.toStringAsFixed(2)}', // Display the progress value
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
