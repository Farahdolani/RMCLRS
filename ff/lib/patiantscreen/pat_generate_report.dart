import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

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
        child: FutureBuilder<User?>(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text('Error fetching user data.'));
            }

            final user = snapshot.data!;
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('patient2')
                  .doc(user.uid)
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
                    return DayReportCard(
                        reportData: report.data() as Map<String, dynamic>);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DayReportCard extends StatelessWidget {
  final Map<String, dynamic> reportData;

  const DayReportCard({Key? key, required this.reportData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report for ${reportData['date']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
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
                      child: Center(child: Text('Progress')),
                    ),
                    TableCell(
                      child: Container(
                        color: const Color.fromARGB(255, 15, 212, 21),
                        child: Center(child: Text('100%')),
                      ),
                    ),
                    TableCell(
                      child: Container(
                        color: Color.fromARGB(255, 15, 212, 21),
                        child: Center(child: Text('100%')),
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
                        color: Color.fromARGB(255, 15, 212, 21),
                        child: Center(child: Text('15/15')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            
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
          'Patient: ${reportData['name']}\nDevice ID: ${reportData['deviceid']}\nDate: ${reportData['date']}}',
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
          minY: 0,
          maxY: 7, // Adjust this based on your EMG data range
        ),
      ),
    );
  }
}
