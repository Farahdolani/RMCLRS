import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatelessWidget {
  final String patientDocId;

  ReportsPage(this.patientDocId);

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
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('patient2')
              .doc(patientDocId)
              .collection('report')
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No reports available.'));
            }

            final reports = snapshot.data!.docs;

            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ReportCard(
                  reportData: report.data() as Map<String, dynamic>,
                  patientDocId: patientDocId,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final String patientDocId;

  const ReportCard(
      {Key? key, required this.reportData, required this.patientDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DynamicReportPage(
                  reportData: reportData, patientDocId: patientDocId)),
        );
      },
      child: Card(
        child: ListTile(
          leading: Icon(Icons.article),
          title: Text('Report for ${reportData['date']}'),
          subtitle: Text('Physician: ${reportData['physicianName']}'),
        ),
      ),
    );
  }
}

class DynamicReportPage extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final String patientDocId;

  const DynamicReportPage(
      {Key? key, required this.reportData, required this.patientDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report for ${reportData['date']}'),
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
                      Text('Patient: ${reportData['name']}'),
                      Text('Device ID: ${reportData['deviceid']}'),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${reportData['date']}'),
                      Text('Physician: ${reportData['physicianName']}'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            EMGChart(emgData: reportData['emg_readings']),
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
                      child: Center(child: Text('Phase')),
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
                      child: Center(child: Text('Progress')),
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
                      child: Center(child: Text('Repetition')),
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
                  final file =
                      File('${output!.path}/report_${reportData['date']}.pdf');
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
    final imageBytes = await rootBundle.load('assets/images/report.jfif');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Report for ${reportData['date']}',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.Text(
          'Patient: ${reportData['name']}\nDevice ID: ${reportData['deviceid']}\nDate: ${reportData['date']}\nPhysician: ${reportData['physicianName']}',
        ),
        pw.SizedBox(height: 20),
        pw.Image(image),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headers: ['Phase', 'Exercise 1', 'Exercise 2'],
          data: [
            ['Progress', '100%', '33%'],
            ['Repetition', '15/15', '3/15'],
          ],
        ),
      ],
    );
  }
}

class EMGChart extends StatelessWidget {
  final List<dynamic> emgData;

  EMGChart({required this.emgData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];

    // Mapping EMG data to FlSpot
    for (int i = 0; i < emgData.length; i++) {
      spots.add(FlSpot(i * 0.25.toDouble(), emgData[i].toDouble()));
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.3),
                                  ),
              color: Colors.blue,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
            ),
          ],
          minX: 0,
         // maxX: (emgData.length - 1).toDouble() * 0.25,
          minY: 0,
          maxY: 7, // Adjust this based on your EMG data range
        ),
      ),
    );
  }
}