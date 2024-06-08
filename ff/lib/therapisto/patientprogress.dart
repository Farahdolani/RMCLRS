import 'package:flutter/material.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:ff/therapisto/report_phase.dart';
import 'package:ff/therapisto/send_feedback.dart'; // Import the SendFeedbackPage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff/therapisto/doctor_plist.dart'; // Import the PatientsList page

class User3 extends StatefulWidget {
  final String patientName;
  final String patientDocId; // Add userUid to hold the patient's user_uid

  User3({required this.patientName,  required String this.patientDocId}); // Updated constructor

  @override
  _User3State createState() => _User3State();
}

class _User3State extends State<User3> {
  // Placeholder values for the progress
  double phasesProgress = HomeScreen1.exe / 2;
  double exercisesProgress = HomeScreen1.exe;
  double overallProgress = HomeScreen1.exe * 12.5;

  Future<void> fetchAndUpdateProgress() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is signed in.");
        return;
      }

      // Get a reference to the patient document
      DocumentReference patientRef =
          FirebaseFirestore.instance.collection('patient2').doc(widget.patientDocId);

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

  @override
  void initState() {
    super.initState();
    fetchAndUpdateProgress();
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
              MaterialPageRoute(builder: (context) => PatientsList()),
            );
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200],
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
                color: Colors.grey,
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
                    widget.patientName, // Accessing patientName from widget
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
            _buildCircularElement(1),
            SizedBox(height: 10),
            Text(
              'Exercises',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildCircularElement(HomeScreen1.exe),
            SizedBox(height: 10),
            Text(
              'Overall Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildCircularElement(HomeScreen1.exe * 12.5, showPercentage: true),
            SizedBox(height: 10),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Repophase()),
                      );
                    },
                    child: Text(
                      'Generate a report',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.purple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SendFeedbackPage(  widget.patientDocId)),
                      );
                    },
                    child: Text(
                      'Send feedback',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularElement(double progressValue, {bool showPercentage = false}) {
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
          showPercentage ? '$progressValue%' : '$progressValue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
