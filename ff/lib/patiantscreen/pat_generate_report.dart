import 'dart:io';
import 'package:ff/patiantscreen/patient_progress_page.dart';
import 'package:ff/patiantscreen/report_ph2.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Repophase2()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            7,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: Row(
                children: [
                  Expanded(
                    child: ReportCard(
                      day: index * 2 + 1,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ReportCard(
                      day: index * 2 + 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final int day;

  const ReportCard({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DynamicReportPage(day: day)),
        );
      },
      child: Card(
        child: ListTile(
          leading: Icon(Icons.article),
          title: Text('Day $day Report'),
        ),
      ),
    );
  }
}

class DynamicReportPage extends StatelessWidget {
  final int day;

  const DynamicReportPage({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report for Day $day'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Image.asset(
              './images/report.jfif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
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
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  final content = await _buildPdfContent(context, pdf);
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

                  OpenFile.open(file.path);
                },
                child: Text('Download as PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<pw.Widget> _buildPdfContent(
      BuildContext context, pw.Document pdf) async {
    final imageBytes = await rootBundle.load('./images/report.jfif');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Report for Day $day',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Patient: Zayn Shawahna\nPatient ID: 111\nAge: 23\nGender: Male\nDate: 23/4/2024\nPhysician: Ahmad Waleed',
        ),
        pw.SizedBox(height: 20),
        pw.Image(image),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headers: [' ', 'Exercise 1', 'Exercise 2'],
          data: [
            ['progress', '100%', '33%'],
            ['repetition', '15/15', '3/15'],
          ],
        ),
      ],
    );
  }
}
