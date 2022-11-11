import 'package:flutter/material.dart';

import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign up to Brick Hold Em",
                style: TextStyle(fontSize: 40)),
            ElevatedButton(
              onPressed: (){
                  AuthService().signInWithGoogle();
              },
              child: Text("Google")
            ),
            ElevatedButton(
              onPressed: (){
                  AuthService().signInWithGoogle();

              },
              child: Text("Facebook")
            )
          
            

          ],
        ),
      ),
    );
  }
}
