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
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                AuthService().signOut();
              },
              child: const Text(
                "Log Out",
                style: TextStyle(fontSize: 20),
              ),
            ),
            
          ],
        ),
      ),
    );
  }

}