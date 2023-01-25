import 'package:brick_hold_em/login/create_account%20_password_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccountInformationPage extends StatefulWidget {
  _CreateAccountInformationPageState createState() =>
      _CreateAccountInformationPageState();
}

// TODO: email verificatoin

class _CreateAccountInformationPageState
    extends State<CreateAccountInformationPage> {
  EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
  EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
  EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

  TextStyle formFieldLabelStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    myController.dispose();
    super.dispose();
  }

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
              child: Text("Personal Info",
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Padding(
                //   padding: formFieldLabelPadding,
                //   child: Text(
                //     "First Name",
                //     style: formFieldLabelStyle,
                //   ),
                // ),
                // Padding(
                //   padding: formFieldPadding,
                //   child: TextField(
                //     style: TextStyle(color: Colors.black),
                //     cursorColor: Colors.black,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: InputDecoration(
                //       contentPadding: contentPadding,
                //       filled: true,
                //       fillColor: Colors.white,
                //       hintText: "Enter your First Name",
                //       border: const OutlineInputBorder(),
                //       enabledBorder: const OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.white),
                //       ),
                //       focusedBorder: const OutlineInputBorder(
                //         borderSide: BorderSide(color: Colors.blue),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: formFieldLabelPadding,
                  child: Text(
                    "Full Name",
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
                      hintText: "Enter your Full Name",
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
                    "Email",
                    style: formFieldLabelStyle,
                  ),
                ),
                TextField(
                  controller: myController,
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: contentPadding,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Enter your Email",
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextButton(
                onPressed: () {
                  //print(myController.text);
                  //isEmailUsed(myController.text);
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                           builder: (context) => CreateAccountPasswordPage()));
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

  Future<bool> isEmailUsed(String email) async {
    http.Response response = await http
        .get(Uri.parse('https://brick-hold-em-api.onrender.com/account/$email'));

    Map data = jsonDecode(response.body);
    print("THIS IS IT");
    print(data);
    return true;
  }
}
