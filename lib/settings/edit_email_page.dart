import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditEmailPage extends StatefulWidget {
  _EditEmailPageState createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EMAIL'),
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
              "Edit your email",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
              
                //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)"))],
                initialValue: FirebaseAuth.instance.currentUser!.email!,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                keyboardType: TextInputType.emailAddress, /* TODO: using this as an emial validator is not optimal, need to find better solution */
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
            TextButton(
              child: const Text(
                "UPDATE",
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}