import 'package:brick_hold_em/ads/ads_page.dart';
import 'package:brick_hold_em/competitive_page.dart';
import 'package:brick_hold_em/friends/friends_page.dart';
import 'package:brick_hold_em/howtoplay_page.dart';
import 'package:brick_hold_em/purchase_page.dart';
import 'package:brick_hold_em/settings_page.dart';
import 'package:brick_hold_em/tournament_page.dart';
import 'package:brick_hold_em/views/login/create_account_username_page.dart';
import 'package:brick_hold_em/views/login/new_user_info.dart';
import 'package:brick_hold_em/profile_page.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:brick_hold_em/globals.dart' as globals;


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late Future<List<String>> userInfo;
  final Duration transitionDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    userInfo = _getUserInfo();
    // Check if the current user exists in Firestore. If not, launch sign up flow.
    _checkIfUserExists();
  }

  Future<List<String>> _getUserInfo() async {
    final chips = await storage.read(key: globals.FSS_CHIPS);
    final username = await storage.read(key: globals.FSS_USERNAME);
    return [username ?? 'Player', chips ?? '0'];
  }

  @override
  Widget build(BuildContext context) {
    // Hide system overlays for full-screen experience.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black87,
              Colors.blueGrey.shade900,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with user info.
              _buildHeader(),
              const SizedBox(height: 20),
              // Main Menu Grid (Game Modes)
              Expanded(child: _buildMainGrid()),
              // Bottom Navigation Row (Utility Pages)
              _buildBottomNav(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Header showing user profile picture, username, and chip count.
  Widget _buildHeader() {
    return FutureBuilder(
      future: userInfo,
      builder: (context, snapshot) {
        String username = 'Player';
        String chips = '0';
        if (snapshot.hasData) {
          List<String> data = List<String>.from(snapshot.data as List);
          username = data[0];
          chips = data[1];
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: OpenContainer(
            transitionDuration: transitionDuration,
            closedElevation: 0,
            closedColor: Colors.transparent,
            openBuilder: (context, _) => const ProfilePage(),
            closedBuilder: (context, openContainer) => GestureDetector(
              onTap: openContainer,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    // User profile picture.
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                          ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                          : null,
                      backgroundColor: Colors.grey.shade800,
                      child: FirebaseAuth.instance.currentUser?.photoURL == null
                          ? const Icon(Icons.person, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 15),
                    // Username and chip count.
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$chips chips",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.amber, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the main grid for game modes.
  Widget _buildMainGrid() {
    // Define main menu items with label, color, icon, and target page.
    final List<_MenuItem> items = [
      _MenuItem(
          title: "COMPETITIVE",
          color: Colors.blue,
          icon: Icons.sports_esports,
          target: const CompetitivePage()),
      _MenuItem(
          title: "FRIENDLY",
          color: Colors.teal,
          icon: Icons.group,
          target: const TournamentPage()),
      _MenuItem(
          title: "HOW TO PLAY",
          color: Colors.red,
          icon: Icons.help_outline,
          target: const HowToPlayPage()),
      _MenuItem(
          title: "SETTINGS",
          color: Colors.black,
          icon: Icons.settings,
          target: const SettingsPage()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        children: items.map((item) {
          return OpenContainer(
            transitionDuration: transitionDuration,
            closedElevation: 4,
            closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            closedColor: Colors.white.withOpacity(0.2),
            openBuilder: (context, _) => item.target,
            closedBuilder: (context, openContainer) => GestureDetector(
              onTap: openContainer,
              child: Container(
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: Colors.white, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build the bottom navigation row for utility pages.
  Widget _buildBottomNav() {
    // Define utility items.
    final List<_MenuItem> utilities = [
      _MenuItem(
          title: "ADS",
          color: Colors.black,
          icon: Icons.local_movies_outlined,
          target: const AdsPage()),
      _MenuItem(
          title: "SHOP",
          color: Colors.teal,
          icon: Icons.shopping_bag,
          target: const PurchasePage()),
      _MenuItem(
          title: "FRIENDS",
          color: Colors.blue,
          icon: Icons.group,
          target: const FriendsPage()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: utilities.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: OpenContainer(
                  transitionDuration: transitionDuration,
                  closedElevation: 4,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  closedColor: Colors.white.withOpacity(0.2),
                  openBuilder: (context, _) => item.target,
                  closedBuilder: (context, openContainer) => GestureDetector(
                    onTap: openContainer,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          item.title,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }

  /// Checks if the user exists in Firestore. If not, launches the sign-up flow.
  void _checkIfUserExists() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).get().then((doc) {
      if (!doc.exists) {
        // User does not exist, proceed to create a new account.
        var newUserInfo = NewUserInfo(
          fullName: FirebaseAuth.instance.currentUser!.displayName,
          email: FirebaseAuth.instance.currentUser!.email,
          photoURL: FirebaseAuth.instance.currentUser!.photoURL,
          loginType: globals.LOGIN_TYPE_FACEBOOK,
        );
        _navigateToUsername(null, newUserInfo);
      }
    }, onError: (error) {
      print(error);
    });
  }

  void _navigateToUsername(var credential, NewUserInfo newUserInfo) {
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
}

/// Simple model for menu items.
class _MenuItem {
  final String title;
  final Color color;
  final IconData icon;
  final Widget target;
  _MenuItem(
      {required this.title,
      required this.color,
      required this.icon,
      required this.target});
}