import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool obscureText = true;
  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
    TextStyle formFieldLabelStyle = const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 30, right: 30),
          children: [
            const Center(
                child: Text("Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 30))),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Email",
                    style: formFieldLabelStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: contentPadding,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter your email",
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Password",
                    style: formFieldLabelStyle,
                  ),
                  TextField(
                    obscureText: obscureText,
                    enableSuggestions: false,
                    /* TODO: Look into removing this in the future - autocorrext and enabled suggestions*/
                    autocorrect: false,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        contentPadding: contentPadding,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter your Password",
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            toggle();
                          },
                          child: Text(obscureText ? "SHOW" : "HIDE"),
                        )),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white),
                          ))),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          //minimumSize: Size.fromWidth(double.infinity)
                          ),
                      child: Text("LOGIN"))
                ],
              ),
            ),
            const Center(
                child: Text("- OR -",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w200))),
            const Center(child: Text("Sign in with", style: TextStyle(color: Colors.white),)),
            ElevatedButton.icon(
                onPressed: () {
                  AuthService().signInWithGoogle();
                },
                icon: const Icon(Icons.abc, color: Colors.black),
                label: const Text(
                  "Login with Google",
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    fixedSize: MaterialStatePropertyAll(Size(210, 30)))),
            ElevatedButton.icon(
                onPressed: () {
                  AuthService().signInWithFacebook();
                },
                icon: const Icon(Icons.facebook),
                label: const Text("Login with Facebook"),
                style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                    fixedSize: MaterialStatePropertyAll(Size(210, 30))))
          ],
        ),
      ),
    );
  }
}
