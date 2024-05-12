import 'package:ff/patiantscreen/phasesexes.dart';
import 'package:flutter/material.dart';
import 'package:ff/patiantscreen/exercise.dart';

class ExerciseLearnPage extends StatelessWidget {
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
                // Handle back arrow tap phasesexes
                 Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => phasesexes()));
              },
            ),
            Text(
              'Exercise one!',
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
            Center( // Center the text
              child: Text(
                'SEATED PASSIVE-ASSISTED KNEE EXTENSIONS',
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
                  child: Image.asset("./images/R1.jfif"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Image.asset("./images/R2.jfif"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Image.asset("./images/R3.jfif"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Image.asset("./images/R4.jfif"),
                ),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Exercise(exerciseName: 'SEATED PASSIVE-ASSISTED KNEE EXTENSIONS')),
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
}

