import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class OneReport extends StatefulWidget {
  const OneReport({Key? key}) : super(key: key);

  @override
  State<OneReport> createState() => _OneReportState();
}

class _OneReportState extends State<OneReport> {
  String? patientName;
  String? patientID;
  String? physicianName;
  bool isLoading = true;
  List<FlSpot> emgData = [];
  final GlobalKey _chartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchPatientAndTherapistInfo();
  }

  Future<void> fetchPatientAndTherapistInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('No authenticated user.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      var patientSnapshot = await FirebaseFirestore.instance
          .collection('patient2')
          .doc(user.uid)
          .get();

      if (!patientSnapshot.exists) {
        print('Patient document does not exist.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      var patientData = patientSnapshot.data();
      print('Patient Data: $patientData');

      if (patientData != null) {
        String pId = patientData['pId'];
        print('Patient PID: $pId');

        var therapistSnapshot = await FirebaseFirestore.instance
            .collection('therapist')
            .where('thId', isEqualTo: pId)
            .get();

        if (therapistSnapshot.docs.isEmpty) {
          print('No matching therapist documents.');
          setState(() {
            isLoading = false;
          });
          return;
        }

        var therapistData = therapistSnapshot.docs.first.data();
        print('Therapist Data: $therapistData');

        setState(() {
          patientName = patientData['name'];
          patientID = patientData['deviceId'].toString();
          physicianName = therapistData['thName'];
          isLoading = false;
        });

        await fetchEMGData(); // Call fetchEMGData after fetchPatientAndTherapistInfo has completed
        setState(() {
          isLoading = false;
        });
      } else {
        print('Patient data is null.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchEMGData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('emg');
      await ref.once().then((event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as List<Object?>;

          List<FlSpot> tempData = [];

          for (int i = 0; i < data.length; i++) {
            try {
              tempData.add(FlSpot(i.toDouble(), (data[i] as num).toDouble()));
            } catch (e) {
              print('Error parsing key: $e');
            }
          }
          setState(() {
            print("state emg");
            emgData = tempData;
            isLoading = false;
          });

          // Save the report after fetching EMG data
          saveReport();
        } else {
          print('No EMG data available');
          setState(() {
            isLoading = false;
          });
        }
      });
    } catch (e) {
      print('Error fetching EMG data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Uint8List> capturePng(GlobalKey key) async {
    RenderRepaintBoundary boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> printPage() async {
    final pdf = pw.Document();
    final imageBytes = await capturePng(_chartKey);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Patient: $patientName'),
              pw.Text('Device ID: $patientID'),
              pw.Text('Date: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
              pw.Text('Physician: $physicianName'),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Image(pw.MemoryImage(imageBytes)),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now()); // Current day
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Report for Day $day'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await printPage();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                            Text('Patient: $patientName'),
                            Text('Device ID: $patientID'),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: $currentDate'),
                            Text('Physician: $physicianName'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  RepaintBoundary(
                    key: _chartKey,
                    child: Column(
                      children: [
                        emgData.isEmpty
                            ? Center(child: Text('No EMG data available'))
                            : SizedBox(
                                height: 300,
                                child: LineChart(
                                  LineChartData(
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: emgData,
                                        isCurved: true,
                                        color: Colors.blue,
                                        barWidth: 2,
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.blue.withOpacity(0.3),
                                        ),
                                      ),
                                    ],
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 22,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              '${(value * 0.25).toStringAsFixed(2)}s',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                        ),
                                      ),
                                    ),
                                    minX: 0,
                                    minY: 0,
                                    maxY: 7,
                                  ),
                                ),
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
                                    color: Color.fromARGB(255, 34, 214, 10),
                                    child: Center(child: Text('100%')),
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
                                    color: Color.fromARGB(255, 3, 244, 55),
                                    child: Center(child: Text('15/15')),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> saveReport() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No authenticated user.');
      return;
    }
    
    DateTime now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day);
    String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

    final reportData = {
      'name': patientName,
      'date': formattedDate,
      'deviceid': patientID,
      'physicianName': physicianName,
      'number_of_phases': 1, // replace with actual number of phases if needed
      'emg_readings': emgData.map((spot) => spot.y).toList(),
    };

    try {
      final reportCollection = FirebaseFirestore.instance
          .collection('patient2')
          .doc(user.uid)
          .collection('report');
      
      // Check if a report for the current date already exists
      final querySnapshot = await reportCollection
          .where('date', isEqualTo: formattedDate)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        // No report for the current date, proceed to save the new report
        await reportCollection.add(reportData);
        print('Report saved successfully.');
      } else {
        print('Report for today is already saved.');
      }
    } catch (e) {
      print('Error saving report: $e');
    }
  }
}


