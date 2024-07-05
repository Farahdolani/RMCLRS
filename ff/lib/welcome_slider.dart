import 'package:ff/patiantscreen/home1.dart';
import 'package:flutter/material.dart';
import 'package:ff/therapisto/doctor_plist.dart';



/* class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome Slider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeSlider(),
    );
  }
} */

class WelcomeSlider extends StatefulWidget {
  @override
  _WelcomeSliderState createState() => _WelcomeSliderState();
}

class _WelcomeSliderState extends State<WelcomeSlider> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              buildPage("Welcome", "Welcome to our app RMCLRS!", Color.fromARGB(255, 234, 165, 245)),
              buildPage("Get Started", "Get started and explore our features.", Color.fromARGB(255, 227, 111, 237)),
              buildPage("Enjoy!", "Enjoy using our app!", Color.fromARGB(255, 117, 36, 101)),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>HomeScreen1()),
                );
              },
              child: Text('Skip'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(String title, String description, Color color) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 20.0),
          Text(
            description,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

