import 'dart:convert';

import 'package:brick_hold_em/home_page.dart';
import 'package:brick_hold_em/login/create_account_information_page.dart';
import 'package:brick_hold_em/login/new_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:brick_hold_em/globals.dart' as globals;

import 'login/create_account_username_page.dart';

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
  String errorText = "";
  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(top: 50),
              child: Center(
                  child: Text("Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 30))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: AnimatedOpacity(
                opacity: visibleStatus ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.redAccent[100],
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.close, color: Colors.red),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            errorText,
                            style: const TextStyle(color: Colors.red),
                          ),
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
                        signInWithEmailAndPassword(email, password);
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
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: IconButton(
                        onPressed: () {
                          signInWithFacebook();
                        },
                        icon: Image.asset('assets/images/facebook.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: IconButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        icon: Image.asset("assets/images/google.png")),
                  )
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                children: [
                  const Text(
                    "Dont't have an account?",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CreateAccountInformationPage()));
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

  // TODO: This SHOULD be in auth_service.dart but could not get
  // it to work since  I needed to setState for the error
  // container to appear.
  signInWithEmailAndPassword(email, password) {
    setState(() {
      visibleStatus = false;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          navigateToHomePage();
        })
        .onError((error, stackTrace) {
      var errorString = error.toString();



      if (errorString.contains("too-many-requests")) {
        setErrorMessage("Too many failed attemps, try again later.");
      } else {
        setErrorMessage("Incorrect email/password");
      }
    });
  }

  signInWithFacebook() async {
    // IMPORTANT: FacebookAuth already returns if user email already exists in FirebaseAuth
    setState(() {
      visibleStatus = false;
    });
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from thex   access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    //var userCred = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .then((value) async {
      // Sign in happens
      final userData = await FacebookAuth.instance.getUserData();

      String fullName = userData["name"];
      String email = userData["email"];
      String photoURL = userData["picture"]["data"]["url"];

      var userInfo = NewUserInfo(fullName: fullName, email: email, photoURL: photoURL, loginType: globals.LOGIN_TYPE_FACEBOOK);
      checkIfUserExists(userInfo);
    }).onError((error, stackTrace) {
      
      var errorString = error.toString();

      if (errorString.contains("account-exists")) {
        setErrorMessage("An account with that email already exists.");
      } else {
        setErrorMessage("An error has occured.");
      }
    });
  }

  // Used when logging in with Facebook, this method checks if user exists in
  // Firestore Database. If they do then they are an existing user, if they
  // don't then they are a new user. Proceed to creating username -> profile pic
  checkIfUserExists(NewUserInfo newUserInfo) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;
    final docRef = db.collection("users").doc(uid);
    docRef.get().then((DocumentSnapshot doc) async {
      if (doc.exists) {
        // User exists, add username to FSS then proceed to HomePage
        final result = doc.data() as Map<String, dynamic>;
        String username = result[globals.FSS_USERNAME];
        FlutterSecureStorage storage = const FlutterSecureStorage();
        await storage.write(key: globals.FSS_USERNAME, value: username);
        
        navigateToHomePage();
      } else {
        // User does not exist, proceed to create new account
        navigateToUsername(null, newUserInfo);
      }
    }, onError: (error) {
      print(error);
    });
  }

  signInWithGoogle() async {
    print("hereeeeeeee");
    setState(() {
      visibleStatus = false;
    });

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Check if email is already being used with correct authentication method
    Map result = await isEmailUsed(googleUser!.email, "google.com");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    if (result['result'] == "Authentication method matches.") {
      // Email was found and with the same authenitcaion method

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        final db = FirebaseFirestore.instance;
        final userRef = db.collection(globals.CF_COLLECTION_USERS).doc(FirebaseAuth.instance.currentUser!.uid).get();
        userRef.then((DocumentSnapshot doc) async {
          if (doc.exists) {
            final result = doc.data() as Map<String, dynamic>;
            String username = result[globals.FSS_USERNAME];
            FlutterSecureStorage storage = const FlutterSecureStorage();
            await storage.write(key: globals.FSS_USERNAME, value: username);

            navigateToHomePage();
          } else {
            // TODO: something really went wrong in this thought process
          }
        })
        .onError((error, stackTrace) {
          // TODO: show user there is an error
        });
        navigateToHomePage();
      }).onError((error, stackTrace) {
        // TODO: show user there is an error
      });
      
    } else if (result['result'] == "Authentication method does not match.") {
      // Email was found but with different authenticaion method
      setErrorMessage("An account with that email already exists.");

    } else if (result['result'] == "New user.") {
      // Email was not found, this is a new user
      var newUserInfo = NewUserInfo(
          fullName: googleUser.displayName,
          email: googleUser.email,
          photoURL: googleUser.photoUrl,
          loginType: globals.LOGIN_TYPE_GOOGLE);

      navigateToUsername(credential, newUserInfo);
    } else {
      // There is an error
      print("this is a new user");
    }
  }

  Future<Map> isEmailUsed(String email, String providerID) async {
    String url = "${globals.END_POINT}/sign_in/$email?providerID=$providerID";
    print("URL is here: $url");
    http.Response response = await http.get(Uri.parse(
        '${globals.END_POINT}/sign_in/$email?providerID=$providerID'));

    Map data = jsonDecode(response.body);

    return data;
  }

  void setErrorMessage(String message) {
    setState(() {
      errorText = message;
      visibleStatus = true;
    });
  }

  void navigateToUsername(var credential, NewUserInfo newUserInfo) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateAccountUsernamePage(
                  credential: credential,
                  newUserInfo: newUserInfo,
                )));
  }

  void navigateToHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
