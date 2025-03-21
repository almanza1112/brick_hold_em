import 'package:brick_hold_em/views/login/create_account_profile_picture_page.dart';
import 'package:brick_hold_em/views/login/new_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;

class CreateAccountUsernamePage extends StatefulWidget {
  final credential;
  final NewUserInfo newUserInfo;
  const CreateAccountUsernamePage(
      {Key? key, this.credential, required this.newUserInfo})
      : super(key: key);
      
  @override
  State<CreateAccountUsernamePage> createState() =>
      _CreateAccountUsernamePageState();
}

class _CreateAccountUsernamePageState extends State<CreateAccountUsernamePage> {
  EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
  EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
  EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

  TextStyle formFieldLabelStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
  TextStyle bulletTextStyle = const TextStyle(color: Colors.white);

  final usernameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  String bullet = "\u2022";

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.brown.shade300,
        appBar: AppBar(
          backgroundColor: Colors.brown.shade300,
          shadowColor: Colors.transparent,
          leading: BackButton(
            onPressed: backButton,
          ),
        ),
        body: Stack(children: [
          ListView(
            padding: const EdgeInsets.only(left: 30, right: 30),
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 40),
                child: Center(
                  child: Text("Username",
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
                        "$bullet Only letters, numbers, and '-_' special characters allowed",
                        style: bulletTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: formFieldLabelPadding,
                        child: Text(
                          "Username",
                          style: formFieldLabelStyle,
                        ),
                      ),
                      Padding(
                        padding: formFieldPadding,
                        child: TextFormField(
                          validator: validateUsername,
                          controller: usernameController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: contentPadding,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter Username",
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
          )
        ]),
      ),
      SafeArea(
          child: Align(alignment: Alignment.bottomRight, child: nextButton()))
    ]);
  }

  Widget nextButton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              var newUserInfo = widget.newUserInfo
                  .copyWith(username: usernameController.text.trim());
              navigateToProfilePic(newUserInfo);
            }
          },
          style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5)),
              backgroundColor: WidgetStateProperty.all(Colors.red),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.red)))),
          child: const Text(
            "NEXT",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  String? validateUsername(String? value) {
    const pattern = r'[a-zA-Z0-9_.-]';
    final regex = RegExp(pattern);

    if (value!.isNotEmpty) {
      if (regex.hasMatch(value)) {
        return null;
      } else {
        return "Invalid username pattern";
      }
    } else {
      return "Field can't be emptyy";
    }
  }

  void navigateToProfilePic(NewUserInfo newUserInfo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateAccountProfilePicturePage(
                credential: widget.credential, newUserInfo: newUserInfo)));
  }

  Future<void> backButton() async {
    if (widget.newUserInfo.loginType == globals.LOGIN_TYPE_FACEBOOK) {
      FirebaseAuth.instance.signOut();
    }
    Navigator.pop(context);
  }
}
