

import 'package:ff/therapisto/report_phase.dart';
import 'package:flutter/material.dart';
import 'package:ff/therapisto/doctor_plist.dart';
import 'package:ff/patiantscreen/exercise_learn.dart';
import 'package:ff/patiantscreen/exercise_learn2.dart';
import 'package:ff/therapisto/generate_report.dart';
import 'package:ff/therapisto/send_feedback.dart';
import 'package:ff/welcome_slider.dart';





class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  // Placeholder values for the progress
  int phasesProgress = 0;
  int exercisesProgress = 0;
  int overallProgress = 0;

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
              MaterialPageRoute(builder: (context) => PatientsList())
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
                    'Zayn Shawahna',
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
            _buildCircularElement(phasesProgress),
             SizedBox(height: 10),
            Text(
              'Exercises',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Placeholder circular progress indicator with value displayed
            _buildCircularElement(exercisesProgress),
             SizedBox(height: 10),
            Text(
              'Overall Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Placeholder circular progress indicator with value displayed as percentage
            _buildCircularElement(overallProgress, showPercentage: true),
             SizedBox(height: 10),
            // Add some space between progress and buttons
            SizedBox(height: 5),// Add some space between progress and buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons to the sides
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30, // Adjust width of button
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Add rounded edges
                    color: Colors.purple,
                  ),
                  child: TextButton(
                    onPressed: () {
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Repophase()),
                      );                    },
                    child: Text(
                      'Generate a report',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 30, // Adjust width of button
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Add rounded edges
                    color: Colors.purple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SendFeedbackPage()),
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

  Widget _buildCircularElement(int progressValue, {bool showPercentage = false}) {
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
          showPercentage ? '$progressValue%' : '$progressValue', // Display the progress value
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
       
      ],
    );
  }
}
