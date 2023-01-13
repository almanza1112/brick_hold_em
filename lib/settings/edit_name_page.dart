import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class EditNamePage extends StatefulWidget {
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  bool visibleName = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('NAME'),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SwitchListTile(
                  title: const Text(
                    "Visible on profile and search results",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w200),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  value: visibleName,
                  onChanged: (bool value) {
                    setState(() {
                      visibleName = value;
                    });
                  }),
            ),
            const Text(
              "Edit your name",
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
                initialValue: FirebaseAuth.instance.currentUser!.displayName!,
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
