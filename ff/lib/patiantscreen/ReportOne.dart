import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    fetchPatientAndTherapistInfo();
    fetchEMGData();
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
      // Ensure Firebase is initialized
      await Firebase.initializeApp();

      // Reference to the EMG readings in the Firebase Realtime Database
      DatabaseReference ref = FirebaseDatabase.instance.ref('emg_readings');

      // Listen to changes in the data
      ref.onValue.listen((event) {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as List<dynamic>;
          List<FlSpot> tempData = [];
          for (int i = 0; i < data.length; i++) {
            tempData.add(FlSpot(i * 0.25, data[i].toDouble()));
          }
          setState(() {
            emgData = tempData;
          });
        } else {
          print('No EMG data available');
        }
      });
    } catch (e) {
      print('Error fetching EMG data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String day = DateFormat('EEEE').format(DateTime.now()); // Current day
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Report for Day $day'),
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
                                  color:Colors.blue,
                                  barWidth: 2,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: 
                                      Colors.blue.withOpacity(0.3),
                                    
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
    );
  }
}
