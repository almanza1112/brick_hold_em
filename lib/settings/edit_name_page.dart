import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNamePage extends StatefulWidget {
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  bool visibleName = true;
  final user = FirebaseAuth.instance.currentUser;
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: user!.displayName);
  }

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
      body: ListView(
        padding: const EdgeInsets.only(left: 40, right: 40),
        children: [
          Wrap(
            direction: Axis.horizontal,
            children: [
               Container(
                color: Colors.greenAccent[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      Text(
                        "Name changed succesuful!",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.greenAccent[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Row(
                children: const [
                  Icon(Icons.check, color: Colors.green,),
                  Text("Name changed succesuful!", style: TextStyle(color: Colors.green),)
                ],
              ),
            ),
          ),
          Form(
            child: Padding(
              padding: const EdgeInsets.only(top:70, bottom: 20),
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
          ),
          const Center(
            child: Text(
              "Edit your name",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: TextFormField(
              validator: validateName,
              controller: nameController,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
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
            onPressed: () {
              updateName();
            },
          ),
        ],
      ),
    );
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return "Field can't be empty";
    } else {
      return null;
    }
  }

  updateName() {
    user!
        .updateDisplayName(nameController.text.trim())
        .then((value) => print("I DID IT"))
        .onError((error, stackTrace) => print("i did not do IT!!!!"));
  }
}
