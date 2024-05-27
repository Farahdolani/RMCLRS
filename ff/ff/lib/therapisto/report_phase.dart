 import 'package:ff/therapisto/generate_report.dart';
import 'package:ff/therapisto/patientprogress.dart';
import 'package:flutter/material.dart';

class Repophase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String feedback = ''; // State variable to hold feedback

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => User())
              
            ); // Go back when arrow is pressed
          },
        ),
      ),

 body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportsPage()));
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Phase 1'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Phase 2'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Phase 3'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text(
                  'phase 4',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
