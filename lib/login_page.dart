import 'package:brick_hold_em/login/create_account_information_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();

}

class LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  bool visibleStatus = false;
  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
    TextStyle formFieldLabelStyle = const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
    EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);

    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(left: 30, right: 30),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, bottom: 0),
              child:
                  Image(image: AssetImage('assets/images/BrickHoldEmLogo.png')),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 60, bottom: 15),
              child: Center(
                  child: Text("Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 30))),
            ),
            AnimatedOpacity(
              opacity: visibleStatus ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Center(
                child: Container(
                  color: Colors.greenAccent[100],
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
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
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: formFieldLabelPadding,
                    child: Text(
                      "Email",
                      style: formFieldLabelStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: contentPadding,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter your email",
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
                      "Password",
                      style: formFieldLabelStyle,
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: obscureText,
                    enableSuggestions: false,
                    /* TODO: Look into removing this in the future - autocorrext and enabled suggestions*/
                    autocorrect: false,
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    
                    decoration: InputDecoration(
                      
                        contentPadding: contentPadding,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter your Password",
                        border: const OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        suffixIcon: TextButton(
                          onPressed: () {
                            toggle();
                          },
                          child: Text(obscureText ? "SHOW" : "HIDE"),
                        )),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white),
                          ))),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          visibleStatus = false;
                        });
                        var email = emailController.text.trim();
                        var password = passwordController.text.trim();
                        AuthService().signInWithEmailAndPassword(email, password);
                      },
                      style: ElevatedButton.styleFrom(
                          //minimumSize: Size.fromWidth(double.infinity)
                          ),
                      child: const Text("LOGIN"))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Center(
                  child: Text("- OR -",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w200))),
            ),
            const Center(
                child: Text(
              "Sign in with",
              style: TextStyle(color: Colors.white),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: IconButton(
                        onPressed: () {
                          AuthService().signInWithFacebook();
                        },
                        icon: Image.asset('assets/images/facebook.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: IconButton(
                        onPressed: () {
                          AuthService().signInWithGoogle();
                        },
                        icon: Image.asset("assets/images/google.png")),
                  )
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  const Text("Dont't have an account?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
                  TextButton(
                      onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccountInformationPage()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ])
          ],
        ),
      ),
    );
  }

   showError() {
    setState(() {
      visibleStatus = !visibleStatus;
    });
  }
}
