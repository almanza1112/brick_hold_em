import 'package:brick_hold_em/game/player.dart';
import 'package:flutter/material.dart';

class PlayerProfilePage extends StatefulWidget {
  final Player player;
  const PlayerProfilePage({super.key, required this.player});

  PlayerProfilePageState createState() => PlayerProfilePageState();
}

class PlayerProfilePageState extends State<PlayerProfilePage> {
  TextStyle buttonTextStyle =
      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          )),
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.player.photoUrl!),
                        radius: 60,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Center(
                          child: Text(
                        widget.player.name!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // use whichever suits your need

                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () {
                                  addFriend();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber),
                                child: Text(
                                  'ADD FRIEND',
                                  style: buttonTextStyle,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () {
                                  reportPlayer();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber),
                                child: Text(
                                  'REPORT',
                                  style: buttonTextStyle,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ]),
    );
  }

  void addFriend() {}

  void reportPlayer() {}
}
