import 'package:ff/login/patiantlogin.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:ff/patiantscreen/pat_generate_report.dart';
import 'package:ff/patiantscreen/phasesexes.dart';
import 'package:ff/patiantscreen/profile.dart';
import 'package:ff/therapisto/doctor_plist.dart';
import 'package:flutter/material.dart';

class phase extends StatefulWidget {
  const phase({super.key});

  @override
  State<phase> createState() => _phaseState();
}

class _phaseState extends State<phase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        //  backgroundColor: Theme.of(context).primaryColor,
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
                MaterialPageRoute(builder: (context) => ReportsPage2()),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const phasesexes()));
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Phase 1'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Phase 2'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text('Phase 3'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Button 1 action
                },
                /* style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 123, 33, 224)), // Set the background color
                ), */
                child: Text(
                  'phase 4',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
