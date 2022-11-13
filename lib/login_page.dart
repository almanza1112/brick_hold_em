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
      backgroundColor: Colors.brown,
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Brick Hold Em",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ElevatedButton.icon(onPressed: (){

              }, 
              icon: const Icon(
                Icons.abc, 
                color: Colors.black
                ), 
              label: const Text(
                "Login with Google", 
                style: TextStyle(color: Colors.black),
                ),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.white),
                fixedSize: MaterialStatePropertyAll(Size(230, 30))
              )       
            ),

            ElevatedButton.icon(
              onPressed: (){

              }, 
              icon: const Icon(Icons.apple), 
              label: const Text(
                "Login with Apple ID",
                style: TextStyle(color: Colors.white)),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
                fixedSize: MaterialStatePropertyAll(Size(230, 30))
              ),
            ),

            ElevatedButton.icon(
              onPressed: (){

              }, 
              icon: const Icon(Icons.facebook), 
              label: const Text("Login with Facebook"),
              style: const ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(230, 30))
              )
            )
          ],
        ),
      ),
    );
  }
}
