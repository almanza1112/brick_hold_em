import 'package:brick_hold_em/game/game.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;

class CompetitivePage extends ConsumerStatefulWidget {
  const CompetitivePage({super.key});

  @override
  CompetitivePageState createState() => CompetitivePageState();
}

class CompetitivePageState extends ConsumerState {
  EdgeInsets titlePadding = const EdgeInsets.only(top: 30, bottom: 0, left: 10);

  bool friendlySwitch = false;
  bool privateSwitch = false;
  TextStyle textStyle = const TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300);
  TextStyle titleStyle = const TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);

  late VideoPlayerController _controller;
  final storage = const FlutterSecureStorage();
  late Future<String?> chips;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/door_closing.mp4');
    chips = getChips();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            title: const Text('NO LIMIT'),
            backgroundColor: Colors.blue,
            shadowColor: Colors.transparent,
            leading: BackButton(
              onPressed: () {
                _controller.dispose();
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
              child: Material(
            color: Colors.blue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: titlePadding,
                  child: Text(
                    "MODE",
                    style: titleStyle,
                  ),
                ),
                SwitchListTile(
                    title: Text("Private", style: textStyle),
                    value: privateSwitch,
                    activeColor: Colors.green.shade500,
                    onChanged: (bool value) {
                      setState(() {
                        privateSwitch = value;
                      });
                    }),
                Padding(
                  padding: titlePadding,
                  child: Text(
                    "TABLE",
                    style: titleStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 150,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          // TODO: need to apply selection of table logic
                        },
                        enlargeCenterPage: true,
                        enlargeFactor: .7,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        enableInfiniteScroll: false,
                        aspectRatio: 2,
                      ),
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) {
                        int itemIndexAdjusted = itemIndex + 1;
                        int tableValue = itemIndexAdjusted * 100;
                        return Container(
                          height: 150,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white)),
                          child: Center(
                              child: Text(
                            tableValue.toString(),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.w700),
                          )),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: titlePadding,
                  child: Text(
                    "CHIPS",
                    style: titleStyle,
                  ),
                ),
                chipSlider(),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () {
                        _controller.initialize().then((value) {
                          setState(() {
                            _controller.play().then((value) {
                              Future.delayed(const Duration(seconds: 2))
                                  .then((val) {
                                    addUserToTable();
                                  });
                            });
                          });
                        });
                      },
                      child: const Text("START",
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ))
              ],
            ),
          )),
        ),

        //if (_controller.value.isInitialized)
        IgnorePointer(
            child: Hero(
                tag: 'videoPlayer',
                child: _controller.value.isInitialized
                    ? VideoPlayer(_controller)
                    : const SizedBox.shrink())),
      ],
    );
  }

  double currentSliderValue = 200;
  Widget chipSlider() {
    return FutureBuilder<String?>(
        future: chips,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("errrrrr");
          }
          if (snapshot.hasData) {
            final data = snapshot.data!;
            final chips = double.parse(data);
            return StatefulBuilder(builder: ((context, setState) {
              return Column(
                children: [
                  Slider(
                      thumbColor: Colors.white,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      //label: "${currentSliderValue.round().toString()} asds",
                      value: currentSliderValue,
                      max: chips,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValue = value;
                        });
                      }),
                  Center(
                    child: Text(
                      "${currentSliderValue.round()} / ${chips.round()}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Center(
                  //   child: RichText(text: TextSpan(
                  //     text: "${currentSliderValue.round().toString()} / ",
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //     children: <TextSpan>[
                  //       TextSpan(text: ref.read(userChipsProvider).toString(), style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18))
                  //     ]
                  //   )),
                  // )
                  // Center(
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Text(currentSliderValue.round().toString()),
                  //       Text(" / "),
                  //       Text(ref.read(userChipsProvider).toString())
                  //     ],
                  //   ),
                  // )
                ],
              );
            }));
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<String?> getChips() async {
    return await storage.read(key: globals.FSS_CHIPS);
  }

  addUserToTable() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final username = await storage.read(key: globals.FSS_USERNAME);

    var body = {
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
      'username': username,
      'chips': currentSliderValue.round().toString()
    };

    http.Response response = await http
        .post(Uri.parse("${globals.END_POINT}/table/join"), body: body);

    if (response.statusCode == 201) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => GamePage(
              controller: _controller,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } else {
      // Status code == 500, there is an error adding user to table
      // TODO: show some error flow here, possible dospose video and show error text
      // to try again later.
    }
  }
}
