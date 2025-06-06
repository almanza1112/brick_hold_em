import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditEmailPage extends StatefulWidget {
  const EditEmailPage({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;
  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final user = FirebaseAuth.instance.currentUser;
  var emailController = TextEditingController();
  String email = "";
  bool visibleStatus = false;


  @override
  void initState() {
    super.initState();
    // Assign to email variable so it can be used to reauthenticate user
    email = user!.email!;
    emailController = TextEditingController(text: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EMAIL'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Email changed succesuful!",
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Center(
              child: Text(
                "Edit your email",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: TextFormField(
              controller: emailController,
              //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)"))],
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              keyboardType: TextInputType.emailAddress,
              /* TODO: using this as an emial validator is not optimal, need to find better solution */
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
          TextButton(
            child: const Text(
              "UPDATE",
            ),
            onPressed: () {
              updateEmail();
            },
          ),
        ],
      ),
    );
  }

  updateEmail() {
    setState(() {
      visibleStatus = false;
    });

    String updatedEmail = emailController.text.trim();

    //AuthCredential authCredential = EmailAuthProvider.credential(email: email, password: "sad");
    //user!.reauthenticateWithCredential(authCredential);
    user!.updateEmail(updatedEmail).then((value) {
      setState(() {
        visibleStatus = !visibleStatus;
      });
      widget.onChanged(updatedEmail);
    }).onError((error, stackTrace) {
      print(error);
    });
  }
}
