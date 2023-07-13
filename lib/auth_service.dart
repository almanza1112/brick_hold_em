import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';
import 'login/login_page.dart';

class AuthService {

  handleAuthStateNew() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}
