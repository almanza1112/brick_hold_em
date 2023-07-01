import 'package:brick_hold_em/game/game.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';
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
  FlutterSecureStorage storage = const FlutterSecureStorage();
  late double chips;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/door_closing.mp4');
    getChips();
    super.initState();
  }

  getChips() async {
    await storage.read(key: globals.FSS_CHIPS);
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
                        //print(currentSliderValue.round());

                        _controller.initialize().then((value) {
                          setState(() {
                            _controller.play().then((value) {
                              Future.delayed(const Duration(seconds: 2))
                                  .then((val) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      
                                        builder: (context) =>
                                             GamePage(controller: _controller,)));
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
        Hero(tag: 'videoPlayer', child: VideoPlayer(_controller)),
      ],
    );
  }

  double currentSliderValue = 200;
  Widget chipSlider() {
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
              "${currentSliderValue.round()} / $chips",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
  }

  // TODO:
  // Not using this code below but will be used as an example for how
  // the list of table images shoudl be done
  // final List<Widget> imageSliders = imgList
  //     .map((item) => SizedBox(
  //           child: Container(
  //             margin: const EdgeInsets.all(5.0),
  //             child: ClipRRect(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 child: Stack(
  //                   children: <Widget>[
  //                     Image.network(item, fit: BoxFit.cover, width: 1000.0),
  //                     Positioned(
  //                       bottom: 0.0,
  //                       left: 0.0,
  //                       right: 0.0,
  //                       child: Container(
  //                         decoration: const BoxDecoration(
  //                           gradient: LinearGradient(
  //                             colors: [
  //                               Color.fromARGB(200, 0, 0, 0),
  //                               Color.fromARGB(0, 0, 0, 0)
  //                             ],
  //                             begin: Alignment.bottomCenter,
  //                             end: Alignment.topCenter,
  //                           ),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                             vertical: 10.0, horizontal: 20.0),
  //                         child: Text(
  //                           'No. ${imgList.indexOf(item)} image',
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 20.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 )),
  //           ),
  //         ))
  //     .toList();
}

// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
// ];
