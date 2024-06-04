import 'package:ff/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login/therapistlogin.dart';
import 'login/patiantlogin.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  //FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RMCLRS',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 37, 37, 34)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TwoButtonsWithImage(),
        '/second': (context) => AuthPage(),
      },
    );
  }
}

class TwoButtonsWithImage extends StatelessWidget {
  const TwoButtonsWithImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 5),
        child: Column(
          children: [
            // Place your large image here
            Center(
              child: Text(
                'RMCLRS',
                style: TextStyle(
                  fontSize: 36.0, // Font size
                  fontWeight: FontWeight.bold, // Font weight
                  fontStyle: FontStyle.italic, // Font style
                  color: Color.fromARGB(255, 123, 33, 224), // Text color
                  letterSpacing: 1.7, // Letter spacing
                  wordSpacing: 3.0,
                ),
              ),
            ),
            SizedBox(height: 5), // Add space between image and buttons
            Image.asset(
              'assets/image/Capture.PNG', // Replace with your image path
              fit: BoxFit.cover,
              // Ensures image fills available height
            ),
            // Add some padding to avoid buttons overlapping the image
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Button 1
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 1 press
                        Navigator.pushNamed(context, '/second');
                      },
                      child: const Text('Patient'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 123, 33, 224),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(300.0, 50.0), // Set width and height
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    // Button 2
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 2 press
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AuthPagee(),
                          ),
                        );
                      },
                      child: const Text('Therapist'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 123, 33, 224),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(300.0, 50.0), // Set width and height
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}