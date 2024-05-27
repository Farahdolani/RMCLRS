import 'package:ff/login/therapistlogin.dart';
import 'package:ff/therapisto/doctor_plist.dart';
import 'package:flutter/material.dart';

class Profiletherapist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Settings'),
          backgroundColor: Color.fromARGB(255, 123, 33, 224),
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
                        Icons.home,
                        color: Colors.white,
                      ),
                      title: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PatientsList()));
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
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: ElevatedButton(
                        onPressed: () {
                          // FirebaseAuth.instance.signOut();

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Auth()));
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
        body: Profile(),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ProfileSettingItem(
          title: 'Name',
          value: 'John Doe',
          onPressed: () => _showEditDialog(context, 'Name'),
        ),
        ProfileSettingItem(
          title: 'Email',
          value: 'john.doe@example.com',
          onPressed: () => _showEditDialog(context, 'Email'),
        ),
        ProfileSettingItem(
          title: 'Therapist_ID',
          value: 'ABC123DEF456',
          onPressed: () => _showEditDialog(context, 'Therapist_ID'),
        ),
        ProfileSettingItem(
          title: 'Password',
          value: '********',
          onPressed: () => _showEditDialog(context, 'Password'),
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, String fieldName) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController newValueController = TextEditingController();

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
            onPressed: () {
              // Check current password
              String currentPassword = passwordController.text;
              if (currentPassword.isNotEmpty) {
                // Proceed to save changes
                // TODO: Implement logic to verify password and update the field
                Navigator.of(context).pop();
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
