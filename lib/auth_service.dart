import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Check if user has document in database
            FirebaseFirestore db = FirebaseFirestore.instance;
            final user = FirebaseAuth.instance.currentUser;
            db.collection("users").doc(user!.uid).get().then(
                (DocumentSnapshot doc) {
              // If document gets returned, user completed profile
              // proceed to HomePage
              final data = doc.data() as Map<String, dynamic>;
              print(data);
              return HomePage();
            }, onError: (e) {
              print("Error getting document: $e");
              return HomePage();
            }).catchError(onError).onError((error, stackTrace) {
              return HomePage();
            });
            doesUserHaveDocument(context);
          } 
          // else if (snapshot.hasError) {
          //   return HomePage();
          // } else if (snapshot.connectionState == ConnectionState.waiting) {
          //   return HomePage();
          // }
          else {
            print(3);

            return const LoginPage();
          }
        });
  }

  onError() {
    return HomePage();
  }

  doesUserHaveDocument(context) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final us = await db.collection("users").doc(user!.uid).get();
  }

  signInWithEmailAndPassword(email, password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {})
        .onError((error, stackTrace) {
      var errorString = error.toString();
      print(error);
      if (errorString.contains("too-many-requests")) {
        print("in the IF");
      }
    });
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
