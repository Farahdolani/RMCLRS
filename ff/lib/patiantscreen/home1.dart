import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff/login/model.dart';
import 'package:ff/login/patiantlogin.dart';
import 'package:ff/patiantscreen/exercise.dart';
import 'package:ff/patiantscreen/not.dart';
import 'package:ff/patiantscreen/pat_generate_report.dart';
import 'package:ff/patiantscreen/patient_progress_page.dart';
import 'package:ff/patiantscreen/phase.dart';
import 'package:ff/patiantscreen/profile.dart';
import 'package:ff/therapisto/patientprogress.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

String Ofline = "Offline";

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});
  static double exe = 0;
  @override
  State<HomeScreen1> createState() => _HomeScreen1();
}

class _HomeScreen1 extends State<HomeScreen1> with WidgetsBindingObserver {
  late Map<String, dynamic> userMap;
  final FirebaseAuth auth = FirebaseAuth.instance; // FirebaseAuth instance

  Future<UserModel> getUserData() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Retreve the user's data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('patient2')
            .doc(user.uid)
            .get();
        print(user.uid);
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null) {
            // Create a UserData instance from the retrieved data
            return UserModel.fromMap({
              'pId': user.uid,
              'name': userData['name'],
              'email': userData['email'],
            });
          }
        }
      }
    } catch (e) {
      // Handle any errors that occurred during the process
      print('Error retrieving user data: $e');
    }
    // If there was an error or the user data couldn't be retrieved, return a default UserData instance
    return UserModel(name: '', email: '', pId: '');
  }

  Future<String> getUserDataString() async {
    final userData = await getUserData();
    print(userData.name);
    return 'Welcome ${userData.name} to RMCLRS!';
  }

  Future<void> fetchAndUpdateProgress() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("No user is signed in.");
        return;
      }

      // Get a reference to the patient document
      DocumentReference patientRef =
          FirebaseFirestore.instance.collection('patient2').doc(user.uid);

      // Fetch the current document snapshot
      DocumentSnapshot snapshot = await patientRef.get();

      if (snapshot.exists) {
        // Get the current progress array
        List<dynamic> progressArray = snapshot['progress'];

        // Store the value at the specified index in HomeScreen1.exe

        HomeScreen1.exe = progressArray[1];
        setState(() {});

        print("Fetched progress: ${HomeScreen1.exe}");
      } else {
        print("Patient document does not exist");
      }
    } catch (e) {
      print("Failed to fetch and update progress: $e");
    }
  }

  void updateProgressAtIndex() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Get a reference to the patient document
    DocumentReference patientRef =
        FirebaseFirestore.instance.collection('patient2').doc(user?.uid);

    // Fetch the current document snapshot
    DocumentSnapshot snapshot = await patientRef.get();

    // Get the current progress array
    List<dynamic> progressArray = snapshot['progress'];

    // Update the element at the specified index
    progressArray[1] = HomeScreen1.exe;
     progressArray[2] = HomeScreen1.exe*12.5;

    // Update the document with the modified array
    await patientRef.update({'progress': progressArray});
  
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    fetchAndUpdateProgress();
  }

  void setStatus(String status) async {
    // Update the user's status in Firestore or Realtime Database
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("online");
    } else {
      // offline
      setStatus("offline");
    }
  }

  void patientOnline(String onof) async {
    // Update the patient's online status in Firebase Realtime Database
  }
  double overallProgress = HomeScreen1.exe * 12.5;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                  context, MaterialPageRoute(builder: (context) => Noti()));
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
                  ListTile(
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
                  ),
                  const Padding(padding: EdgeInsets.all(15)),
                  ListTile(
                    leading: const Icon(
                      Icons.local_hospital_sharp,
                      color: Colors.white,
                    ),
                    title: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportsPage2()),
                        );
                      },
                      child: const Text(
                        "See All Reports",
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
                        updateProgressAtIndex();
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
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'Device is ready',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                  ),
                ),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 8, 224, 26), // Background color
                  borderRadius: BorderRadius.circular(8), // BorderRadius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 5, // Spread radius
                      blurRadius: 7, // Blur radius
                      offset: Offset(0, 3), // Offset
                    ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: FutureBuilder<String>(
                  future: getUserDataString(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 20, 20),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        style: TextStyle(
                          color: Color.fromARGB(255, 19, 78, 142),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      return Text(
                        'Error retrieving user data',
                        style: TextStyle(
                          color: Color.fromARGB(255, 102, 211, 29),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: 150, // Adjust the width and height for the desired size
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: (HomeScreen1.exe * 12.5) / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 75, 237, 25)),
                      strokeWidth:
                          100, // Increase the strokeWidth for a larger indicator
                      backgroundColor: Color.fromARGB(172, 72, 72, 72),
                    ),
                    Text(
                      "${HomeScreen1.exe * 12.5}%",
                      style: TextStyle(
                        fontSize: 24, // Adjust the size as needed
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 245, 245, 245),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Text('YOUR PROGRESS !'),
            ),
            SizedBox(
              height: 70,
            ),
            Center(
              child: SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => phase()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue), // Set the background color
                  ),
                  child: Text(
                    'Go To Phases',
                    style: TextStyle(
                      color: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: SizedBox(
                width: 300,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => User1()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue), // Set the background color
                  ),
                  child: Text(
                    'Show Your Progress',
                    style: TextStyle(
                      color: Colors.white, // Set the text color
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget demoCategories(
    String image,
    String name,
    String drQuality,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 100,
      decoration: BoxDecoration(
        color: const Color(0xff1071613),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'SourceSansPro'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  color: const Color(0xffd9fffa).withOpacity(.07)),
              child: Text(
                drQuality,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontFamily: 'SourceSansPro'),
              ),
            )
          ]),
    );
  }

  Widget demoTopRatedDr(
      String image, String name, String speciality, String rating) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // Navigator.push( context,MaterialPageRoute(builder: (context) =>const DoctorDetails()));
      },
      child: Container(
        height: 90,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              height: 50,
              width: 60,
              child: Image.asset(image),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      name,
                      style: const TextStyle(
                          color: Color(0xff363636),
                          fontSize: 17,
                          fontFamily: 'SourceSansPro',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            speciality,
                            style: const TextStyle(
                              color: Color(0xffababab),
                              fontFamily: 'SourceSansPro',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(top: 3, left: size.width * 0.25),
                          child: Row(
                            children: [
                              const Text(
                                "Rating",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SourceSansPro'),
                              ),
                              Text(
                                rating,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'SourceSansPro'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
