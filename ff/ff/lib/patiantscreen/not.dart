import 'package:ff/login/patiantlogin.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:ff/patiantscreen/profile.dart';
import 'package:flutter/material.dart';

class noti extends StatelessWidget {
  const noti({super.key});

  @override
  Widget build(BuildContext context) {
    final int numberOfContainers = 3;
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
                        //  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen1()));
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
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(
                    top: 10, left: 10), // Add margin only on the top
                child: Text('Ahmad Waleed'),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Expanded(
              // Wrap the ListView.builder with Expanded
              child: ListView.builder(
                itemCount: numberOfContainers,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius:
                          BorderRadius.circular(10), // Set rounded edges
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          spreadRadius: 2, // Spread radius
                          blurRadius: 5, // Blur radius
                          offset: Offset(0, 3), // Offset
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(20),
                    child: Text(
                      'Container ${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
