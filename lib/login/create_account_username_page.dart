import 'package:brick_hold_em/login/create_account_profile_picture_page.dart';
import 'package:flutter/material.dart';

class CreateAccountUsernamePage extends StatefulWidget {
  _CreateAccountUsernamePageState createState() =>
      _CreateAccountUsernamePageState();
}

class _CreateAccountUsernamePageState extends State<CreateAccountUsernamePage> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
    EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
    EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

    TextStyle formFieldLabelStyle = const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
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
              child: Text("Username",
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ),

          Form(child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: formFieldLabelPadding,
                child: Text(
                  "Username",
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
                    hintText: "Enter Username",
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
                          builder: (context) => CreateAccountProfilePicturePage()));
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
