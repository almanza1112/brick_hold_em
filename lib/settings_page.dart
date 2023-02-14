import 'package:brick_hold_em/settings/edit_email_page.dart';
import 'package:brick_hold_em/settings/edit_name_page.dart';
import 'package:brick_hold_em/settings/edit_profile_picture_page.dart';
import 'package:brick_hold_em/settings/edit_username_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/globals.dart' as globals;

import 'auth_service.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  EdgeInsets titlePadding = const EdgeInsets.only(top: 30, bottom: 0, left: 10);
  EdgeInsets accountRowPadding =
      const EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 15);
  String username = "";
  bool backgroundSound = true;
  bool fxSound = true;
  bool vibrate = true;
  bool liveChat = true;
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
    getSwitchValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('SETTINGS'),
          backgroundColor: Colors.black,
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
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditNamePage()));
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
                        FirebaseAuth.instance.currentUser!.displayName!,
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
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditUsernamePage()));
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
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditEmailPage()));
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
                        FirebaseAuth.instance.currentUser!.email!,
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
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePicturePage()));
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
                                child: Text("CANCEL")),
                            TextButton(
                                onPressed: () {
                                  /** TODO: need to clean this up, NOT the correct way of doing this */
                                  Navigator.pop(context);
                                  Navigator.pop(context);

                                  AuthService().signOut();
                                },
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
              SwitchListTile(
                  title: Text(
                    "Background",
                    style: textStyle,
                  ),
                  value: backgroundSound,
                  onChanged: (bool value) {
                    setState(() {
                      backgroundSound = value;
                      setSwitchState(globals.settingsBackgroundSound, value);
                    });
                  }),
              SwitchListTile(
                  title: Text(
                    "FX",
                    style: textStyle,
                  ),
                  value: fxSound,
                  onChanged: (bool value) {
                    setState(() {
                      fxSound = value;
                      setSwitchState(globals.settingsFXSound, value);
                    });
                  }),
              SwitchListTile(
                  title: Text(
                    "Vibrate",
                    style: textStyle,
                  ),
                  value: vibrate,
                  onChanged: (bool value) {
                    setState(() {
                      vibrate = value;
                      setSwitchState(globals.settingsVibrate, value);
                    });
                  }),
              Padding(
                padding: titlePadding,
                child: Text(
                  "GAME",
                  style: titleStyle,
                ),
              ),
              SwitchListTile(
                  title: Text(
                    "Live Chat",
                    style: textStyle,
                  ),
                  value: liveChat,
                  onChanged: (bool value) {
                    setState(() {
                      liveChat = value;
                      setSwitchState(globals.settingsGameLiveChat, value);
                    });
                  }),
              Padding(
                padding: titlePadding,
                child: Text(
                  "NOTIFICATIONS",
                  style: titleStyle,
                ),
              ),
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

  getSwitchValues() async {
   
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? backgroundSoundSwitchState =
        prefs.getBool(globals.settingsBackgroundSound);
    bool? fxSoundSwitchState = prefs.getBool(globals.settingsFXSound);

    bool? vibrateSwitchState = prefs.getBool(globals.settingsVibrate);
    bool? chatSwitchState = prefs.getBool(globals.settingsGameLiveChat);
    String? loggedInUserUsername = prefs.getString(globals.loggedInUserUsername);
    print("THIS $loggedInUserUsername");
    setState(() {
      backgroundSound = backgroundSoundSwitchState!;
      fxSound = fxSoundSwitchState!;
      vibrate = vibrateSwitchState!;
      liveChat = chatSwitchState!;
      username = prefs.getString(globals.loggedInUserUsername)!;
    });
  }

  setSwitchState(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
}
