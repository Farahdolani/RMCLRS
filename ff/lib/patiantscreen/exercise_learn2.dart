import 'package:ff/patiantscreen/phasesexes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ff/patiantscreen/exercise.dart';

class ExerciseLearnPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Handle back arrow tap
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => phasesexes()));
              },
            ),
            Text(
              'Exercise two!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              // Center the text
              child: Text(
                'HEEL SLIDES-KNEE FLEXION AND EXTENSION',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Image.asset("./images/RE2.jfif"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Image.asset("./images/RE22.jfif"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Image.asset("./images/RE222.jfif"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Image.asset("./images/R2222.jfif"),
                ),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                startEx2();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Exercise(
                          exerciseName:
                              'HEEL SLIDES-KNEE FLEXION AND EXTENSION')),
                );
              },
              child: Text(
                'Start Exercising!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startEx2() async {
    try {
      // Ensure Firebase is initialized

      // Reference to the EMG readings in the Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref('start1');

      // Set the value of 'phase1' to true
      await ref.set(true);

      // Listen to changes in the data (code for this would go here if needed)
    } catch (e) {
      print('Error : $e');
    }
  }
}
