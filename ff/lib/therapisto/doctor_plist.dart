import 'package:ff/login/patiantlogin.dart';
import 'package:ff/patiantscreen/not.dart';
import 'package:ff/patiantscreen/profile.dart';
import 'package:flutter/material.dart';
import 'patientprogress.dart'; // Import main.dart to navigate to it

class PatientsList extends StatefulWidget {
  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  List<String> patientNames = [
    'Zayn Shawahneh',
    'Amr Ghassan',
    'Safa Refai',
    'Farah Dolani',
    'Sham Hashim'
  ];

  @override
  Widget build(BuildContext context) {
   // return Scaffold(




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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => noti()));
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
                  //StreamBuilder(
                  // stream: FirebaseFirestore.instance.collection("patient").where("uid",
                  //   isEqualTo: currentUser.currentUser?.uid).snapshots(),

                  //  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                  /*    {
                    if(snapshot.hasData){
                      return ListView.builder(itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true, itemBuilder: (context,i) {


                          var data = snapshot.data!.docs[i];

                          return UserAccountsDrawerHeader(accountName: Text(data["name"]),

                              accountEmail: Text(data["email"]));

                        },
                      );
                    }else{
                      return const CircularProgressIndicator();
                    }
                  },
 */

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
                                builder: (context) => ProfileSettings()));
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
                 /*  ListTile(
                    leading: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen1()));
                      },
                      child: const Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ), */
                  const Padding(padding: EdgeInsets.all(15)),
               /*    ListTile(
                    leading: const Icon(
                      Icons.local_hospital_sharp,
                      color: Colors.white,
                    ),
                    title: ElevatedButton(
                      onPressed: () {
                         Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportsPage()),
              );//  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen1()));
                      },
                      child: const Text(
                        "See All Reports",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ), */
                  const Padding(padding: EdgeInsets.all(15)),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: ElevatedButton(
                      onPressed: () {
                        // FirebaseAuth.instance.signOut();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthPage()));
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
            )),
      ),



      /*appBar: AppBar(
        title: Text('Patients List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientsList()),
              );
          },
        ),/*
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => User()),
              );
            },
          ),
        ],*/
      ),*/
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0), // Padding for the whole page
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the start (left)
            children: [
              // First part of the page
              Row(
                children: [
                  // User icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey, // Placeholder color for the user icon
                    ),
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: const Color.fromARGB(255, 168, 130, 130),
                    ),
                  ),
                  SizedBox(width: 10), // Add some space between the user icon and text
                  // Doctor name
                  Text(
                    'Dr. Ahmad Waleed',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 20), // Add some space between the sections

              // Second part of the page
              // Centered "Patients List" header
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
              SizedBox(height: 10), // Add some space below the header

              // List of patient names
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
          './images/bottomIMAGE.png', // Adjust as needed
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
              color: Colors.grey, // Placeholder color for the user icon
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
                // Handle click for the first patient
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => User()),
                );
              } else {
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
