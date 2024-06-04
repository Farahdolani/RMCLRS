import 'package:ff/main.dart';
import 'package:ff/patiantscreen/home1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'patiantsignup.dart';
import 'forgotpassword.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TwoButtonsWithImage()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/image/R.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(bottom: 5),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 70),
            ),
            SingleChildScrollView(
              child: const Center(
                child: Text(
                  "Welcome",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Center(
              child: Text(
                "Sign in to your account Dear Patiant !",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Login(),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Forgotpass()));
                },
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool obsecurePass = true;

 Future userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
password: password);

Navigator.pushReplacement(context, MaterialPageRoute(builder:
(context) =>HomeScreen1()));
    } on FirebaseAuthException catch (e) {
    
       print("No user found");
       ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text("No user found",
                  style: TextStyle(
                      fontSize: 20
                  ),)
            ));
  
        /* print("Wrong password");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text("No user found",
                  style: TextStyle(
                      fontSize: 20
                  ),)
            )); */
      
    }
  }



  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }








  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please Enter Email";
                                } else if (!value.contains('@')) {
                                  return "Please Enter Valid Email";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                email = val;
                              },
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.email],
                              autocorrect: true,
                              cursorColor: Colors.indigoAccent,
                              decoration: const InputDecoration(
                                hintText: 'Email Address',
                                labelText: ('Email'),
                                alignLabelWithHint: true,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: SingleChildScrollView(
                              child: TextFormField(
                                controller: _passController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please Enter Password";
                                  }
                                  return null;
                                },
                                onChanged: (val) {
                                  password = val;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                cursorColor: Colors.indigoAccent,
                                obscureText: obsecurePass,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  labelText: ('Password'),
                                  alignLabelWithHint: true,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  prefixIconColor: Colors.black,
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obsecurePass = !obsecurePass;
                                        });
                                      },
                                      icon: obsecurePass
                                          ? const Icon(
                                              Icons.visibility_off_outlined,
                                              color: Colors.black38,
                                            )
                                          : const Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.blue,
                                            )),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(left: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          email = _emailController.text;
                                          password = _passController.text;
                                        }
                                      
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        );

                                        /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen1()),
                                        ); */
                                         userLogin();
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 20)),
                                ],
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(left: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 20)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ]))));
  }
}
