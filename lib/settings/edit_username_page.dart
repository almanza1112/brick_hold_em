import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brick_hold_em/globals.dart' as globals;

class EditUsernamePage extends StatefulWidget {
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  String bullet = "\u2022";
  bool visibleStatus = false;
  TextStyle ulTextStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w200);

  var usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('USERNAME'),
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 40, right: 40),
        children: [
          AnimatedOpacity(
            opacity: visibleStatus ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Container(
                color: Colors.greenAccent[100],
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Name changed succesuful!",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 10),
            child: Text(
              "Edit your username using only the following:",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$bullet Any letter in the alphabet",
                style: ulTextStyle,
              ),
              Text(
                "$bullet Any number",
                style: ulTextStyle,
              ),
              Text(
                "$bullet Only '_' and '-' special characters",
                style: ulTextStyle,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9_.-]"))
              ],
              controller: usernameController,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          TextButton(onPressed: () {updateUsername();}, child: const Text("UPDATE")),
        ],
      ),
    );
  }

  getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(globals.loggedInUserUsername);

    setState(() {
      usernameController = TextEditingController(text: username);
    });
  }

  updateUsername() {
    
  }
}
