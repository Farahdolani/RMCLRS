import 'dart:io';
import 'package:ff/patiantscreen/patient_progress_page.dart';
import 'package:ff/patiantscreen/report_ph2.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'package:open_file/open_file.dart';

class ReportsPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports!'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              7,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: DayReportCard(
                  day: index * 2 + 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayReportCard extends StatelessWidget {
  final int day;

  const DayReportCard({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day $day Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient: Zayn Shawahna'),
                      Text('Patient ID: 111'),
                      Text('Age: 23'),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gender: Male'),
                      Text('Date: 23/4/2024'),
                      Text('Physician: Ahmad Waleed'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Image.asset(
              './images/report.jfif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text(' ')),
                    ),
                    TableCell(
                      child: Center(child: Text('Exercise 1')),
                    ),
                    TableCell(
                      child: Center(child: Text('Exercise 2')),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text('progress')),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.green,
                        child: Center(child: Text('100%')),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Color.fromARGB(255, 244, 7, 3),
                        child: Center(child: Text('33%')),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(child: Text('repetition')),
                    ),
                    TableCell(
                      child: Container(
                        color: Colors.green,
                        child: Center(child: Text('15/15')),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Color.fromARGB(255, 244, 7, 3),
                        child: Center(child: Text('3/15')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  /* final pdf = pw.Document();
                //  final content = await _buildPdfContent(context, pdf);
                  pdf.addPage(
                    pw.Page(
                      build: (context) => pw.Center(child: content),
                    ),
                  );

                  final output = await getExternalStorageDirectory();
                  final file = File('${output!.path}/report_$day.pdf');
                  await file.writeAsBytes(await pdf.save());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('PDF downloaded successfully'),
                    ),
                  );

                  OpenFile.open(file.path);*/
                },
                child: Text('Download as PDF'), 
              ),
            ),
          ],
        ),
      ),
    );
  }

}
