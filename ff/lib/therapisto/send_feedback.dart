import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff/therapisto/doctor_plist.dart';
import 'package:flutter/material.dart';

class SendFeedbackPage extends StatelessWidget {
  final String patientUid;

  SendFeedbackPage(this.patientUid);

  @override
  Widget build(BuildContext context) {
    String feedback = ''; // State variable to hold feedback

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Feedback'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => PatientsList()));
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
                  feedback = value;
                
                   // Update feedback when text changes
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
              onPressed: () async {
                if (feedback.isNotEmpty) {
                  await _sendFeedback(patientUid, feedback, context);
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter feedback before sending.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
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

  Future<void> _sendFeedback(
      String patientUid, String feedback, BuildContext context) async {
    try {
      CollectionReference feedbacks = FirebaseFirestore.instance
          .collection('patient2')
          .doc(patientUid)
          .collection('feedbacks');

      await feedbacks.add({
        'message': feedback,
        'timestamp': Timestamp.now(),
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to send feedback: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}


