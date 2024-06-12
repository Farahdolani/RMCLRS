import 'package:ff/therapisto/doctor_plist.dart';
import 'package:ff/therapisto/generate_report.dart';
import 'package:ff/therapisto/patientprogress.dart';
import 'package:flutter/material.dart';

class Repophase extends StatelessWidget {
  final String patientDocId;

  Repophase(this.patientDocId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to ReportsPage with patientDocId
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportsPage(patientDocId)
                    )
                  );
                },
                child: Text('Phase 1'),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Phase 2 action
                },
                child: Text('Phase 2'),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Phase 3 action
                },
                child: Text('Phase 3'),
              ),
            ),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Phase 4 action
                },
                child: Text('Phase 4'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
