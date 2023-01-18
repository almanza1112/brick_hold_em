import 'package:brick_hold_em/login/create_account_username_page.dart';
import 'package:flutter/material.dart';

class CreateAccountPasswordPage extends StatefulWidget {
  _CreateAccountPasswordPageState createState() =>
      _CreateAccountPasswordPageState();
}

class _CreateAccountPasswordPageState extends State<CreateAccountPasswordPage> {
  EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
  EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
  EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

  TextStyle formFieldLabelStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 30, right: 30),
        children: [
           const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: Text("Password",
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ),
          Form(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               Padding(
                padding: formFieldLabelPadding,
                child: Text(
                  "Password",
                  style: formFieldLabelStyle,
                ),
              ),
              Padding(
                padding: formFieldPadding,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter Password",
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
              Padding(
                padding: formFieldLabelPadding,
                child: Text(
                  "Reenter Password",
                  style: formFieldLabelStyle,
                ),
              ),
              Padding(
                padding: formFieldPadding,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Reenter Password",
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
              
            ],
            
          )),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountUsernamePage()));
                },
                child: const Text(
                  "NEXT",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
    );
  }
}
