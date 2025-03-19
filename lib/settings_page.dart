import 'package:brick_hold_em/views/login/login_page.dart';
import 'package:brick_hold_em/settings/edit_email_page.dart';
import 'package:brick_hold_em/settings/edit_name_page.dart';
import 'package:brick_hold_em/settings/edit_profile_picture_page.dart';
import 'package:brick_hold_em/settings/edit_username_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  EdgeInsets titlePadding = const EdgeInsets.only(top: 30, bottom: 0, left: 10);
  EdgeInsets accountRowPadding =
      const EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 15);
  String fullName = FirebaseAuth.instance.currentUser!.displayName!;
  String username = '';
  FlutterSecureStorage storage = const FlutterSecureStorage();

  String email = FirebaseAuth.instance.currentUser!.email!;
  late bool backgroundSound = true;
  late bool fxSound = true;
  late bool vibrate = true;
  late bool liveChat = true;
  bool dailyNotifications = true;
  TextStyle textStyle = const TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w200);
  TextStyle titleStyle = const TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);
  TextStyle accountTextStyle =
      const TextStyle(fontSize: 14, color: Colors.grey);
  Color iconColor = Colors.white;
  double iconSize = 14;

  @override
  void initState() {
    super.initState();
    getUsername().then((value) {
      setState(() {
        username = value ?? '';
      });
    },);
    getSwitchValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('SETTINGS'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Material(
          color: Colors.black,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: titlePadding,
                child: Text(
                  "ACCOUNT",
                  style: titleStyle,
                ),
              ),

              // FULL NAME
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditNamePage(
                                onChanged: (value) {
                                  setState(() {
                                    fullName = value;
                                  });
                                },
                              )));
                },
                child: Padding(
                  padding: accountRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Name",
                        style: textStyle,
                      )),
                      Text(
                        fullName,
                        style: accountTextStyle,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),

              // USERNAME
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUsernamePage(
                                onChanged: (value) {
                                  setState(() {
                                    username = value;
                                  });
                                },
                              )));
                },
                child: Padding(
                  padding: accountRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Username",
                        style: textStyle,
                      )),
                      Text(
                        username,
                        style: accountTextStyle,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),

              // EMAIL
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditEmailPage(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              )));
                },
                child: Padding(
                  padding: accountRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Email",
                        style: textStyle,
                      )),
                      Text(
                        email,
                        style: accountTextStyle,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),

              // PROFILE PICTURE
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePicturePage()));
                },
                child: Padding(
                  padding: accountRowPadding,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Profile Picture",
                        style: textStyle,
                      )),
                      Image(
                          width: 30,
                          height: 30,
                          image: NetworkImage(
                              FirebaseAuth.instance.currentUser!.photoURL!)),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor,
                        size: iconSize,
                      )
                    ],
                  ),
                ),
              ),

              // LOG OUT
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Log Out"),
                          content:
                              const Text("Are you sure you want to log out?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("CANCEL")),
                            TextButton(
                                onPressed: signOut,
                                child: const Text("LOG OUT"))
                          ],
                        );
                      });
                },
                child: Padding(
                  padding: accountRowPadding,
                  child: Text(
                    "Log Out",
                    style: textStyle,
                  ),
                ),
              ),

              Padding(
                padding: titlePadding,
                child: Text(
                  "SOUND & HAPTICS",
                  style: titleStyle,
                ),
              ),

              // BACKGROUND
              SwitchListTile(
                  title: Text(
                    "Background",
                    style: textStyle,
                  ),
                  value: backgroundSound,
                  onChanged: (bool value) {
                    setState(() {
                      backgroundSound = value;
                      setSwitchState(globals.SETTINGS_BACKGROUND_SOUND, value);
                    });
                  }),

              // FX
              SwitchListTile(
                  title: Text(
                    "FX",
                    style: textStyle,
                  ),
                  value: fxSound,
                  onChanged: (bool value) {
                    setState(() {
                      fxSound = value;
                      setSwitchState(globals.SETTINGS_FX_SOUND, value);
                    });
                  }),

              // VIBRATE
              SwitchListTile(
                  title: Text(
                    "Vibrate",
                    style: textStyle,
                  ),
                  value: vibrate,
                  onChanged: (bool value) {
                    setState(() {
                      vibrate = value;
                      setSwitchState(globals.SETTINGS_VIBRATE, value);
                    });
                  }),

              Padding(
                padding: titlePadding,
                child: Text(
                  "GAME",
                  style: titleStyle,
                ),
              ),

              // LIVE CHAT
              SwitchListTile(
                  title: Text(
                    "Live Chat",
                    style: textStyle,
                  ),
                  value: liveChat,
                  onChanged: (bool value) {
                    setState(() {
                      liveChat = value;
                      setSwitchState(globals.SETTINGS_GAME_LIVE_CHAT, value);
                    });
                  }),

              Padding(
                padding: titlePadding,
                child: Text(
                  "NOTIFICATIONS",
                  style: titleStyle,
                ),
              ),

              // DAILY
              SwitchListTile(
                  title: Text(
                    "Daily",
                    style: textStyle,
                  ),
                  value: dailyNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      dailyNotifications = value;
                    });
                  }),
            ],
          ),
        ));
  }

  Future<void> getSwitchValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      backgroundSound =
          prefs.getBool(globals.SETTINGS_BACKGROUND_SOUND) ?? false;
      fxSound = prefs.getBool(globals.SETTINGS_FX_SOUND) ?? false;
      vibrate = prefs.getBool(globals.SETTINGS_VIBRATE) ?? false;
      liveChat = prefs.getBool(globals.SETTINGS_GAME_LIVE_CHAT) ?? false;
    });
  }

  Future<String?> getUsername() async {
    var username = await storage.read(key: globals.FSS_USERNAME);
    return username;
  }

  setSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  void signOut() async {
    // Delete all Settings
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    // Sign out of Firebase
    FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (_) => false);
    }
  }
}
