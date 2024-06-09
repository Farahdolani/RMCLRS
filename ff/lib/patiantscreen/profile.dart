import 'package:ff/login/patiantlogin.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Settings',style: TextStyle(
    color: Colors.white,
  ),),
          backgroundColor: Colors.purple,
        ),
        drawer: Drawer(
          child: Container(
              color:Colors.purple,
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
                          FirebaseAuth.instance.signOut();
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
        body: ProfileSettingsScreen(),
      ),
    );
  }
}

class ProfileSettingsScreen extends StatefulWidget {
  @override
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _name;
  String? _email;
  String? _deviceId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('patient2').doc(user.uid).get();

      if (doc.exists) {
        setState(() {
          _name = doc['name'];
          _email = doc['email'];
          _deviceId = doc['deviceId'];
          _isLoading = false;
        });
      } else {
        print("Document does not exist");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("User is not authenticated");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showEditDialog(
      BuildContext context, String fieldName, String initialValue) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController newValueController =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Text('Edit $fieldName'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter current password',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: newValueController,
              decoration: InputDecoration(
                hintText: 'Enter new $fieldName',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              String currentPassword = passwordController.text;

              if (currentPassword.isNotEmpty) {
                User? user = _auth.currentUser;

                if (user != null) {
                  AuthCredential credential = EmailAuthProvider.credential(
                    email: user.email!,
                    password: currentPassword,
                  );

                  try {
                    await user.reauthenticateWithCredential(credential);

                    if (fieldName == 'Password') {
                      await user.updatePassword(newValueController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password updated successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      await _updateUserField(
                          user.uid, fieldName, newValueController.text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$fieldName updated successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }

                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update $fieldName: $e'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter your current password'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserField(
      String uid, String fieldName, String newValue) async {
    await _firestore
        .collection('patient2')
        .doc(uid)
        .update({fieldName.toLowerCase(): newValue});
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              ProfileSettingItem(
                title: 'Name',
                value: _name ?? 'Loading...',
                onPressed: () => _showEditDialog(context, 'Name', _name ?? ''),
              ),
              ProfileSettingItem(
                title: 'Email',
                value: _email ?? 'Loading...',
                onPressed: () =>
                    _showEditDialog(context, 'Email', _email ?? ''),
              ),
              ProfileSettingItem(
                title: 'Device ID',
                value: _deviceId ?? 'Loading...',
                onPressed: () =>
                    _showEditDialog(context, 'Device ID', _deviceId ?? ''),
              ),
              ProfileSettingItem(
                title: 'Password',
                value: '********',
                onPressed: () => _showEditDialog(context, 'Password', ''),
              ),
            ],
          );
  }
}

class ProfileSettingItem extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onPressed;

  const ProfileSettingItem({
    Key? key,
    required this.title,
    required this.value,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      onTap: onPressed,
    );
  }
}
