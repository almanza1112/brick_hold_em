import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthService {

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
             return HomePage();
          }
          else {
            return const LoginPage();
          }
        });
  }

  handleAuthStateNew() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    } else {
      return HomePage();
    }
  }

  onError() {
    return HomePage();
  }


  signOut() {
    FirebaseAuth.instance.signOut();
  }

}
