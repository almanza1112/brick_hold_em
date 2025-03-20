import 'dart:convert';

import 'package:brick_hold_em/game/game.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:flutter/services.dart';

class CompetitivePage extends ConsumerStatefulWidget {
  const CompetitivePage({super.key});

  @override
  CompetitivePageState createState() => CompetitivePageState();
}

class CompetitivePageState extends ConsumerState<CompetitivePage> {
  // Styling and padding
  final EdgeInsets titlePadding =
      const EdgeInsets.only(top: 30, bottom: 10, left: 20);
  final TextStyle sectionTitleStyle = const TextStyle(
      fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600);
  final TextStyle valueStyle = const TextStyle(
      fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold);

  // Video controller for door-closing transition
  late VideoPlayerController _controller;

  // Secure storage to retrieve chips value.
  final storage = const FlutterSecureStorage();
  late Future<String?> chipsFuture;

  // Carousel & Slider state
  double currentChipValue = 200;
  int currentTableValue = 100; // default table value from carousel
  final int carouselItemCount = 5;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/door_closing.mp4');
    chipsFuture = _getChips();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _getChips() async {
    return await storage.read(key: globals.FSS_CHIPS);
  }

  @override
  Widget build(BuildContext context) {
    // Force the system UI (status bar and navigation bar) to show.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    // Optionally, adjust the status bar icon brightness if needed.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // same as background
      statusBarIconBrightness: Brightness.light,
    ));

    return Stack(
      children: [
        Scaffold(
          // Blue background is maintained.
          backgroundColor: Colors.blue,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Dispose video before going back.
                _controller.dispose();
                Navigator.pop(context);
              },
            ),
            // Remove title from the AppBar.
            title: const SizedBox.shrink(),
          ),
          body: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Custom header for Competitive mode.
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      "COMPETITIVE",
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // TABLE selection section
                  Padding(
                    padding: titlePadding,
                    child: Text("TABLE", style: sectionTitleStyle),
                  ),
                  _buildTableCarousel(),
                  const SizedBox(height: 20),
                  // CHIPS selection section
                  Padding(
                    padding: titlePadding,
                    child: Text("CHIPS", style: sectionTitleStyle),
                  ),
                  _buildChipSlider(),
                  const Spacer(),
                  // START button
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: ElevatedButton(
                      onPressed: _onStartPressed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // Changed to amber for contrast with blue.
                        backgroundColor: Colors.amber,
                      ),
                      child: const Text("START",
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        // Video overlay via Hero (ignoring pointer so it doesn’t block interaction)
        IgnorePointer(
          child: Hero(
            tag: 'videoPlayer',
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  /// Build the table selection carousel.
  Widget _buildTableCarousel() {
    return CarouselSlider.builder(
      itemCount: carouselItemCount,
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          setState(() {
            // Each table increases by 100 chips requirement.
            currentTableValue = (index + 1) * 100;
          });
        },
      ),
      itemBuilder: (context, index, realIndex) {
        int tableValue = (index + 1) * 100;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white54, width: 2),
          ),
          child: Center(
            child: Text(
              tableValue.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build the chip slider widget.
  Widget _buildChipSlider() {
    return FutureBuilder<String?>(
      future: chipsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Text("Error loading chips",
                  style: TextStyle(color: Colors.white)));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final totalChips = double.tryParse(snapshot.data!) ?? 0;
        // Ensure currentChipValue does not exceed totalChips.
        if (currentChipValue > totalChips) {
          currentChipValue = totalChips;
        }
        return StatefulBuilder(
          builder: (context, setStateSlider) {
            return Column(
              children: [
                Slider(
                  thumbColor: Colors.white,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: currentChipValue,
                  max: totalChips,
                  min: 0,
                  onChanged: (double value) {
                    setStateSlider(() {
                      currentChipValue = value;
                    });
                  },
                ),
                Text(
                  "${currentChipValue.round()} / ${totalChips.round()}",
                  style: valueStyle,
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Called when the START button is pressed.
  void _onStartPressed() {
    // Initialize and play the video.
    _controller.initialize().then((_) {
      setState(() {
        _controller.play().then((_) {
          // After 2 seconds, add user to the table and navigate.
          Future.delayed(const Duration(seconds: 2), () {
            _addUserToTable();
          });
        });
      });
    });
  }

  /// Sends a POST request to add the user to the table, then navigates to GamePage.
  void _addUserToTable() async {
    final username = await storage.read(key: globals.FSS_USERNAME);
    var body = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
      'username': username,
      'chips': currentChipValue.round().toString(),
      'table': currentTableValue.toString(),
    };

    http.Response response = await http.post(
      Uri.parse("${globals.END_POINT}/table/join"),
      body: body,
    );

    if (response.statusCode == 201) {
      if (context.mounted) {
        // Update provider with player's position.
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        ref.read(playerPositionProvider.notifier).state =
            responseBody['position'];

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                GamePage(controller: _controller),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } else {
      // On error: pause video and show an error dialog.
      _controller.pause();
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Error"),
                content: const Text(
                    "Failed to join table. Please try again later."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"))
                ],
              ));
    }
  }
}