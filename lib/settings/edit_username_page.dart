import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditUsernamePage extends StatefulWidget {
  _EditUsernamePageState createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EDIT USERNAME'),
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
              "Edit your username",
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
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
                  //labelText: 'Edit your name',
                  
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            MaterialButton(
              child: Text("Submit", style: TextStyle(color: Colors.white),),
              color: Colors.red,
              onPressed: (){},
              ),
          ],
        ),
      ),
    );
  }
}