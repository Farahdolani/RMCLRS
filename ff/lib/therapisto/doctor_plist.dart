import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff/therapisto/patientprogress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ff/login/patiantlogin.dart';
import 'package:ff/login/therapistlogin.dart';
import 'package:ff/therapisto/nottherapist.dart';
import 'package:ff/therapisto/therapist_profile.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class PatientsList extends StatefulWidget {
  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  List<String> patientNames = [];

  @override
  void initState() {
    super.initState();
    fetchPatientNames();
  }

  Future<void> fetchPatientNames() async {
    String therapistId = '';

    // Fetch the therapist document based on the current user's ID
    DocumentSnapshot therapistSnapshot = await FirebaseFirestore.instance
        .collection('therapist')
        .doc(auth.currentUser!.uid)
        .get();

    // Check if the therapist document exists
    if (therapistSnapshot.exists) {
      // Get the therapist ID (thId) from the document
      therapistId = therapistSnapshot['thId'];

      // Query Firestore to get the patient names associated with the therapist ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('patient2')
          .where('pId', isEqualTo: therapistId)
          .get();

      // Extract patient names from the query snapshot
      List<String> names = [];
      querySnapshot.docs.forEach((doc) {
        names.add(doc['name']);
      });

      // Update the patient names in the state
      setState(() {
        patientNames = names;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromARGB(255, 123, 33, 224),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => nottherapist()));
            },
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.integration_instructions,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 123, 33, 224),
          child: SafeArea(
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(15)),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profiletherapist()));
                    },
                    child: const Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(15)),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: ElevatedButton(
                    onPressed: () async {
                      await auth.signOut(); // Sign out the user
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => AuthPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: const Color.fromARGB(255, 168, 130, 130),
                    ),
                  ),
                  SizedBox(width: 10),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('therapist')
                        .doc(auth.currentUser!.uid)
                        .get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        String therapistName = snapshot.data!['thName'];
                        return Text(
                          'Dr. $therapistName',
                          style: TextStyle(fontSize: 18),
                        );
                      } else {
                        return Text(
                          'Dr. Placeholder',
                          style: TextStyle(fontSize: 18),
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Patients List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: patientNames.length,
                itemBuilder: (context, index) {
                  return buildPatientCard(patientNames[index], index);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        child: Image.asset(
          './images/bottomIMAGE.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPatientCard(String name, int index) {
    return Center(
      child: Card(
        child: ListTile(
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            child: Icon(
              Icons.person,
              size: 20,
              color: const Color.fromARGB(255, 168, 130, 130),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.pushReplacement(      
                  context,
                  MaterialPageRoute(builder: (context) => User3(patientName: patientNames[index])),
                );
              } else  {
                // Handle click for other patients (if needed)
              }
            },
            child: Text(
              name,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
