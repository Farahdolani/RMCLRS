import 'package:ff/login/patiantlogin.dart';
import 'package:ff/patiantscreen/ReportOne.dart';
import 'package:ff/patiantscreen/exercise.dart';
import 'package:ff/patiantscreen/exercise_learn.dart';
import 'package:ff/patiantscreen/exercise_learn2.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:ff/patiantscreen/pat_generate_report.dart';
import 'package:ff/patiantscreen/profile.dart';
import 'package:ff/therapisto/doctor_plist.dart';
import 'package:flutter/material.dart';

class phasesexes extends StatefulWidget {
  const phasesexes({super.key});

  @override
  State<phasesexes> createState() => _phasesexesState();
}

class _phasesexesState extends State<phasesexes> {
  int buttonEnabled = 2; // Initialize the variable
  double flag = HomeScreen1.exe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        //  backgroundColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.purple,
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
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.integration_instructions_sharp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
            color: Colors.purple,
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
                          color: Colors.black,
                        ),
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
                          color: Colors.black,
                        ),
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
                        ); //  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen1()));
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExerciseLearnPage()));
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Exercise 1'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 2 action
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExerciseLearnPage2()));
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Exercise 2'),
              ),
            ),
            SizedBox(
              height: 200,
            ),

            /////hiiiiiii we are died...
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 8, 224, 26), // Set the button color to red
                ),
                onPressed: HomeScreen1.exe == 8 || HomeScreen1.exe == 0
                    ? () {
                        print(Exercise.plus);
                        // Button 3 action
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OneReport()));
                        print("Button 3 pressed");
                      }
                    : null,
                child: Text(
                  'Daily Report !',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
