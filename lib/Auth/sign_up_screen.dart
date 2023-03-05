import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String?> mailRegister(String mail, String pwd) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: mail, password: pwd);
      Fluttertoast.showToast(msg: "Sign Up Success! Please Login...");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
      return null;
    } on FirebaseAuthException catch (ex) {
      print("Error ${ex.code} ${ex.message}");
      return "${ex.code}: ${ex.message}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Enter Password',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        mailRegister(
                            emailController.text, passwordController.text);
                        emailController.clear();
                        passwordController.clear();
                      });
                    },
                    child: const Text('Sign Up')),
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    child: const Text('You have account please Login')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
