import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNamePage extends StatefulWidget {
  const EditNamePage({ required this.onChanged});

  final ValueChanged<String> onChanged;
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  bool visibleName = true;
  bool visibleStatus = false;
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
          AnimatedOpacity(
            opacity: visibleStatus ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Container(
                color: Colors.greenAccent[100],
                child: const Padding(
                  padding:  EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
          Form(
            child: Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 20),
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
    setState(() {
      visibleStatus = false;
    });
    
    String updatedName = nameController.text.trim();
    user!.updateDisplayName(updatedName).then((value) {
      setState(() {
        visibleStatus = !visibleStatus;
      });
      widget.onChanged(updatedName);
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
