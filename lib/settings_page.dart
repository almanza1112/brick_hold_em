import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.brown,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 64.0, top: 16.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Image(image: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                FirebaseAuth.instance.currentUser!.displayName!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  AuthService().signOut();
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

}