import 'package:ff/therapisto/doctor_plist.dart';
import 'package:ff/therapisto/patientprogress.dart';
import 'package:flutter/material.dart';

class SendFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String feedback = ''; // State variable to hold feedback

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => PatientsList())
              
            ); // Go back when arrow is pressed
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  feedback = value; // Update feedback when text changes
                },
                maxLines: null, // Allow multiple lines of text
                decoration: InputDecoration(
                  hintText: 'Enter your feedback...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate sending feedback by displaying it in a dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Feedback Sent'),
                      content: Text(feedback),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Send Feedback'),
                  Icon(Icons.send),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
