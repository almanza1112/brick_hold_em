import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        });
  }

  signInWithEmailAndPassword(email, password) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print("it works");
    }).onError((error, stackTrace) {
      
      var errorString = error.toString();
      if(errorString.contains("wrong-password")) {
        LoginPageState().showError();
      }
      print(error.toString().contains("firebase"));


    });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    var userCred = await FirebaseAuth.instance.signInWithCredential(credential);

    return checkIfUserExists(userCred);
  }

  signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from thex   access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    var userCred = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    return checkIfUserExists(userCred);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  checkIfUserExists(var userCred) {
    // Get the UID of the user from Firebase Authentication
    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;

    // Check if user already exists in Firestore Database
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        // If it does exist then proceed to return the user credentials
        return userCred;
      } else {
        // If it does not exist then create a document with Id equal to the Firebase
        // Authentication User UID, also give user n chips
        db
            .collection("users")
            .doc(uid)
            .set({
              'chips': 1000,
              //'name': FirebaseAuth.instance.currentUser!.displayName,
              //'photoURL': FirebaseAuth.instance.currentUser!.photoURL
            })
            .then((value) => print("User Added"))
            .catchError((error) => print("Failed to add user: $error"));
      }
    });
  }
}
