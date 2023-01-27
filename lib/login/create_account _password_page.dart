import 'package:brick_hold_em/login/create_account_username_page.dart';
import 'package:flutter/material.dart';

class CreateAccountPasswordPage extends StatefulWidget {
  _CreateAccountPasswordPageState createState() =>
      _CreateAccountPasswordPageState();
}

class _CreateAccountPasswordPageState extends State<CreateAccountPasswordPage> {
  EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
  EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
  EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

  TextStyle formFieldLabelStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
  TextStyle bulletTextStyle = const TextStyle(color: Colors.white);

  String bullet = "\u2022";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(left: 30, right: 30),
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Center(
                  child: Text("Password",
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$bullet Minimum of 6 characters",
                        style: bulletTextStyle,
                      ),
                      Text(
                        "$bullet Uppercase or lowercase letters A-Z",
                        style: bulletTextStyle,
                      ),
                      Text(
                        "$bullet Numbers 0-9",
                        style: bulletTextStyle,
                      ),
                      Text(
                        "$bullet Special characters .!@#\$%^&*()-_ allowed",
                        style: bulletTextStyle,
                      )
                    ],
                  ),
                ),
              ),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: formFieldLabelPadding,
                    child: Text(
                      "Password",
                      style: formFieldLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formFieldPadding,
                    child: TextFormField(
                      validator: validatePassword,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: contentPadding,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter Password",
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: formFieldLabelPadding,
                    child: Text(
                      "Reenter Password",
                      style: formFieldLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: formFieldPadding,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: contentPadding,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Reenter Password",
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ],
          ),
          SafeArea(
              child:
                  Align(alignment: Alignment.bottomRight, child: nextButton()))
        ],
      ),
    );
  }

  Widget nextButton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateAccountUsernamePage()));
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.red)))),
          child: const Text(
            "NEXT",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

String? validatePassword(String? value) {
    const pattern = '[a-zA-Z0-9_.!@#\$%^&*()-]';
    final regex = RegExp(pattern);

    if (value!.isNotEmpty) {
      if (!regex.hasMatch(value)) {
        return "Password does not match";
      } else {
        return null;
      }
    } else {
      return "Field can't be empty";
    }
  }

}
