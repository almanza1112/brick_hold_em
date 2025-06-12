import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:brick_hold_em/home_page.dart';
import 'package:brick_hold_em/views/login/create_account_information_page.dart';
import 'package:brick_hold_em/views/login/create_account_username_page.dart';
import 'package:brick_hold_em/views/login/new_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  bool showError = false;
  String errorText = "";

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  // Accent colors from the game’s card palette.
  final Color cardRed = Colors.redAccent;
  final Color cardGreen = Colors.greenAccent;
  final Color cardBlue = Colors.lightBlueAccent;
  final Color cardDark = Colors.black87;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent back navigation so users don't return to the splash screen.
      canPop: false,
      child: Scaffold(
        body: Container(
          // Full-screen gradient using the game’s card colors.
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cardDark,
                cardBlue.withOpacity(0.85),
                cardGreen.withOpacity(0.85),
                cardRed.withOpacity(0.85)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hero widget for logo transition.
                    Hero(
                      tag: 'logoHero',
                      child: Image.asset(
                        'assets/images/logos/BrickHoldEmLogo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Glassmorphic login card.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              if (showError)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: cardRed.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error,
                                          color: Colors.red),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          errorText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              // Email TextField.
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  prefixIcon: const Icon(Icons.email,
                                      color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Password TextField.
                              TextFormField(
                                controller: passwordController,
                                obscureText: obscureText,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: const TextStyle(color: Colors.black87),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.black54),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  suffixIcon: TextButton(
                                    onPressed: togglePasswordVisibility,
                                    child: Text(
                                      obscureText ? "Show" : "Hide",
                                      style: TextStyle(
                                        color: cardBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Implement forgot password functionality.
                                  },
                                  child: const Text("Forgot Password?"),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showError = false;
                                  });
                                  String email = emailController.text.trim();
                                  String password =
                                      passwordController.text.trim();
                                  signInWithEmailAndPassword(email, password);
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: cardGreen,
                                ),
                                child: const Text("Login",
                                    style: TextStyle(fontSize: 18)),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                      child:
                                          Divider(color: Colors.grey.shade400)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text("or",
                                        style: TextStyle(
                                            color: Colors.grey.shade600)),
                                  ),
                                  Expanded(
                                      child:
                                          Divider(color: Colors.grey.shade400)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Social login buttons.
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: signInWithFacebook,
                                    icon: Image.asset(
                                      'assets/images/logos/facebook.png',
                                      width: 48,
                                    ),
                                    iconSize: 48,
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    onPressed: signInWithGoogle,
                                    icon: Image.asset(
                                      'assets/images/logos/google.png',
                                      width: 48,
                                    ),
                                    iconSize: 48,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Sign up prompt.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CreateAccountInformationPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Email/Password sign-in method.
  void signInWithEmailAndPassword(String email, String password) {
    setState(() {
      showError = false;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      navigateToHomePage();
    }).onError((error, stackTrace) {
      String errorStr = error.toString();
      if (errorStr.contains("too-many-requests")) {
        setErrorMessage("Too many failed attempts, please try again later.");
      } else {
        setErrorMessage("Incorrect email or password.");
      }
    });
  }

  // Facebook sign-in method.
  Future<void> signInWithFacebook() async {
    setState(() {
      showError = false;
    });

    // Generate nonce
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final LoginResult loginResult = await FacebookAuth.instance
        .login(loginTracking: LoginTracking.limited, nonce: nonce);

    if (loginResult.status == LoginStatus.success) {}

    // Create a credential from the access token
    OAuthCredential facebookAuthCredential;
    if (Platform.isIOS) {
      switch (loginResult.accessToken!.type) {
        case AccessTokenType.classic:
          final token = loginResult.accessToken as ClassicToken;
          facebookAuthCredential = FacebookAuthProvider.credential(
            token.authenticationToken!,
          );
          break;

        case AccessTokenType.limited:
          final token = loginResult.accessToken as LimitedToken;
          facebookAuthCredential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: token.tokenString,
            rawNonce: rawNonce,
          );
          break;
      }
    } else {
      facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    }

    FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential)
        .then((value) async {
      final userData = await FacebookAuth.instance.getUserData();
      String fullName = userData["name"];
      String email = userData["email"];
      String photoURL = userData["picture"]["data"]["url"];
      var userInfo = NewUserInfo(
        fullName: fullName,
        email: email,
        photoURL: photoURL,
        loginType: globals.LOGIN_TYPE_FACEBOOK,
      );
      checkIfUserExists(userInfo);
    }).onError((error, stackTrace) {
      String errorStr = error.toString();
      print(error);
      if (errorStr.contains("account-exists")) {
        setErrorMessage("An account with that email already exists.");
      } else {
        setErrorMessage("An error occurred during Facebook sign in.");
      }
    });
  }

  // Check if user exists in Firestore.
  void checkIfUserExists(NewUserInfo newUserInfo) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then(
      (doc) async {
        if (doc.exists) {
          final result = doc.data() as Map<String, dynamic>;
          FlutterSecureStorage storage = const FlutterSecureStorage();
          await storage.write(
              key: globals.FSS_USERNAME, value: result[globals.FSS_USERNAME]);
          await storage.write(
              key: globals.FSS_CHIPS,
              value: result[globals.FSS_CHIPS].toString());
          setSettings();
          navigateToHomePage();
        } else {
          navigateToUsername(null, newUserInfo);
        }
      },
      onError: (error) {
        print(error);
      },
    );
  }

  // Google sign-in method.
  Future<void> signInWithGoogle() async {

    setState(() {
      showError = false;
    });
    await GoogleSignIn(scopes: ["email"]).signOut();
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: ["email"]).signIn();

    // TODO: isEmailUsed not working. need to fix this
    //Map result = await isEmailUsed(googleUser!.email, "google.com");

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //if (result['result'] == "Authentication method matches.") {
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        FirebaseFirestore.instance
            .collection(globals.CF_COLLECTION_USERS)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((doc) async {
          if (doc.exists) {
            final data = doc.data() as Map<String, dynamic>;
            String username = data[globals.FSS_USERNAME];
            FlutterSecureStorage storage = const FlutterSecureStorage();
            await storage.write(key: globals.FSS_USERNAME, value: username);
            await storage.write(
                key: globals.FSS_CHIPS,
                value: data[globals.FSS_CHIPS].toString());
            setSettings();
            navigateToHomePage();
          }
        }).onError((error, stackTrace) {});
      }).onError((error, stackTrace) {});
    // } else if (result['result'] == "Authentication method does not match.") {
    //   setErrorMessage("An account with that email already exists.");
    // } else if (result['result'] == "New user.") {
    //   var newUserInfo = NewUserInfo(
    //     fullName: googleUser.displayName,
    //     email: googleUser.email,
    //     photoURL: googleUser.photoUrl,
    //     loginType: globals.LOGIN_TYPE_GOOGLE,
    //   );
    //   navigateToUsername(credential, newUserInfo);
    // } else {
    //   print("Unexpected authentication result.");
    // }
  }

  Future<Map> isEmailUsed(String email, String providerID) async {
    final response = await http.get(Uri.parse(
        '${globals.END_POINT}/sign_in/$email?providerID=$providerID'));
    return jsonDecode(response.body);
  }

  void setErrorMessage(String message) {
    setState(() {
      errorText = message;
      showError = true;
    });
  }

  void navigateToUsername(var credential, NewUserInfo newUserInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountUsernamePage(
          credential: credential,
          newUserInfo: newUserInfo,
        ),
      ),
    );
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  void setSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(globals.SETTINGS_BACKGROUND_SOUND, true);
    prefs.setBool(globals.SETTINGS_FX_SOUND, true);
    prefs.setBool(globals.SETTINGS_VIBRATE, true);
    prefs.setBool(globals.SETTINGS_GAME_LIVE_CHAT, true);
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
