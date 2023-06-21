import 'dart:async';

import 'package:brick_hold_em/login/create_account%20_password_page.dart';
import 'package:brick_hold_em/login/new_user_info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:brick_hold_em/globals.dart' as globals;

class CreateAccountInformationPage extends StatefulWidget {
  _CreateAccountInformationPageState createState() =>
      _CreateAccountInformationPageState();
}

class _CreateAccountInformationPageState
    extends State<CreateAccountInformationPage> {
  EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
  EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
  EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

  TextStyle formFieldLabelStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  double progressBarValue = 0;
  bool progressBarVisibile = false;
  String? emailIsAlreadyUsed;

  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              Visibility(
                visible: progressBarVisibile,
                child: Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      value: progressBarValue,
                    )),
              ),
              ListView(
                padding: const EdgeInsets.only(left: 30, right: 30),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 40),
                    child: Center(
                      child: Text("Personal Info",
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Padding(
                        //   padding: formFieldLabelPadding,
                        //   child: Text(
                        //     "First Name",
                        //     style: formFieldLabelStyle,
                        //   ),
                        // ),
                        // Padding(
                        //   padding: formFieldPadding,
                        //   child: TextField(
                        //     style: TextStyle(color: Colors.black),
                        //     cursorColor: Colors.black,
                        //     keyboardType: TextInputType.emailAddress,
                        //     decoration: InputDecoration(
                        //       contentPadding: contentPadding,
                        //       filled: true,
                        //       fillColor: Colors.white,
                        //       hintText: "Enter your First Name",
                        //       border: const OutlineInputBorder(),
                        //       enabledBorder: const OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.white),
                        //       ),
                        //       focusedBorder: const OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.blue),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: formFieldLabelPadding,
                          child: Text(
                            "Full Name",
                            style: formFieldLabelStyle,
                          ),
                        ),
                        Padding(
                          padding: formFieldPadding,
                          child: TextFormField(
                            validator: validateName,
                            controller: nameController,
                            style: TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding: contentPadding,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter your Full Name",
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
                            "Email",
                            style: formFieldLabelStyle,
                          ),
                        ),
                        TextFormField(
                          validator: validateEmail,
                          controller: emailController,
                          style: const TextStyle(color: Colors.black),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding: contentPadding,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Enter your Email",
                            errorText: emailIsAlreadyUsed,
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: nextButton(),
          ),
        )
      ],
    );
  }

  Widget nextButton() {
                    print(globals.END_POINT);

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              // Make progress bar visible
              setState(() {
                progressBarVisibile = true;
              });
              progressBarValue = 0; // Reset progress bar value
              determinateIndicator();
              Map result = await isEmailUsed(emailController.text.trim());

              if (result['emailAvailable']) {
                // Email is available

                progressBarValue = 1; // progress bar is complete
                // Make progress bar invisible
                setState(() {
                  progressBarVisibile = false;
                });
                var newUserInfo = NewUserInfo(fullName: nameController.text.trim(), email: emailController.text.trim(), loginType: globals.LOGIN_TYPE_EMAIL);
                navigateToCreatePassword(newUserInfo);
              } else if (!result['emailAvailable']) {
                // Email is not available
                setState(() {
                  emailIsAlreadyUsed =
                      "An account with this email already exists";
                });

                progressBarValue = 1; // Progress Bar complete
                // Make Progress Bar invisible
                setState(() {
                  progressBarVisibile = false;
                });
              } else {
                // There is an error, server side most likeely
                print("something is wrong");
              }
            }
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

  Future<Map> isEmailUsed(String email) async {
    http.Response response = await http.get(
        Uri.parse('https://brick-hold-em-api.onrender.com/account/$email'));

    Map data = jsonDecode(response.body);

    return data;
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return "Field can't be empty";
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    if (value!.isNotEmpty) {
      if (regex.hasMatch(value)) {
        return null;
      } else {
        return "Enter valid email address";
      }
    } else {
      return "Field can't be empty";
    }
  }

  void determinateIndicator() {
    Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      setState(() {
        if (progressBarValue == 1) {
          timer.cancel();
        } else {
          if (progressBarValue < 0.8) {
            progressBarValue = progressBarValue + 0.1;
          }
        }
      });
    });
  }

  void navigateToCreatePassword(NewUserInfo newUserInfo){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CreateAccountPasswordPage(newUserInfo: newUserInfo,)));
  }
}
