import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditUsernamePage extends StatefulWidget {
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  String bullet = "\u2022";
  TextStyle ulTextStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w200);
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
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Edit your username using only the following:",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Column(
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9_.-]"))
                ],
                initialValue: FirebaseAuth.instance.currentUser!.uid,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
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
            TextButton(onPressed: () {}, child: const Text("UPDATE")),
          ],
        ),
      ),
    );
  }
}
