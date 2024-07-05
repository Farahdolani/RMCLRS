import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:ff/welcome_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  var userName = "";
  var thId = "";
  var dId = "";
  var email = "";
  var password = "";

  final _userNameController = TextEditingController();
  final _thIdController = TextEditingController();
  final _dIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool obsecurePass = true;
  String? deviceErrorMessage;

  Future userSignup() async {
    try {
      // Step 1: Check if the deviceId exists and its status
      DocumentSnapshot deviceSnapshot = await FirebaseFirestore.instance
          .collection('Devices')
          .doc(dId)
          .get();

      if (deviceSnapshot.exists) {
        // Step 2: If the deviceId exists, check its status
        if (deviceSnapshot['status'] == 'reserved') {
          // If the device is already reserved, show error message
          setState(() {
            deviceErrorMessage = "This device is already reserved";
          });
          return;
        } else {
          // If the device is available, update its status to reserved
          await FirebaseFirestore.instance
              .collection('Devices')
              .doc(dId)
              .update({'status': 'reserved'});
        }
      } else {
        // Step 3: If the deviceId does not exist, create it with status reserved
        await FirebaseFirestore.instance
            .collection('Devices')
            .doc(dId)
            .set({'deviceId': dId, 'status': 'reserved'});
      }

      // Step 4: Create user and store patient data
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('patient2')
          .doc(userCredential.user?.uid)
          .set({
        'name': userName,
        'pId': thId,
        'deviceId': dId,
        'email': email,
        'rool': 'p',
        'progress': [1, 0, 0],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Account created successfully",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomeSlider()));
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Error: $e",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _thIdController.dispose();
    _dIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/R.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _userNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter user name";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    userName = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'User Name',
                    labelText: 'User Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _thIdController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter TH_ID";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    thId = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'TH_ID',
                    labelText: 'TH_ID',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _dIdController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter D_ID";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    dId = val;
                  },
                  decoration: const InputDecoration(
                    hintText: 'D_ID',
                    labelText: 'D_ID',
                    prefixIcon: Icon(Icons.perm_identity),
                  ),
                ),
              ),
              if (deviceErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    deviceErrorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email";
                    } else if (!value.contains('@')) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    email = val;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                  onChanged: (val) {
                    password = val;
                  },
                  obscureText: obsecurePass,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecurePass = !obsecurePass;
                        });
                      },
                      icon: obsecurePass
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        userName = _userNameController.text;
                        thId = _thIdController.text;
                        dId = _dIdController.text;
                        email = _emailController.text;
                        password = _passwordController.text;
                        deviceErrorMessage = null; // Clear previous error message
                      });
                      userSignup();
                    }
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
