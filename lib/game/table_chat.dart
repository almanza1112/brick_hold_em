import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TableChat extends ConsumerStatefulWidget {
  const TableChat({
    Key? key,
  }) : super(key: key);

  @override
  _TableChatState createState() => _TableChatState();
}

class _TableChatState extends ConsumerState<TableChat> {
  DatabaseReference chatRef = FirebaseDatabase.instance.ref('tables/1/chat');
  OverlayEntry? overlayEntry;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool pos1 = false, pos2 = false, pos3 = false, pos4 = false;

  @override
  Widget build(BuildContext context) {
    // The sized box has to be the same height as the game_players
    return SizedBox(
      child: StreamBuilder(
          stream: chatRef.limitToLast(1).onChildAdded,
          builder: ((context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<dynamic, dynamic> data =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

              late Widget t;

              if (data['playerInfo']['uid'] != uid) {
                num position =
                    (data['position'] - ref.read(playerPositionProvider)) - 1;

                if (position < 0) {
                  position = 6 + position;
                }
                t = showOverlay(data['text'], position.toInt());
              } else {
                t = const SizedBox();
              }
              return t;
            } else {
              return Container();
            }
          })),
    );
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }
  bool visible = true;

  Widget showOverlay(String message, int position) {
    bool top = false, bottom = false, right = false, left = false;
    late double topNum, leftNum, rightNum;
    switch (position) {
      case 0:
        // Bottom right
        bottom = true;
        right = true;
        rightNum = 20;
        break;

      case 1:
        // Top right
        top = true;
        right = true;
        topNum = 140;
        rightNum = 20;
        break;

      case 2:
        // Top center
        top = true;
        left = true;
        right = true;
        topNum = 15;
        leftNum = 0;
        rightNum = 0;
        break;

      case 3:
        // Top left
        top = true;
        left = true;
        topNum = 140;
        leftNum = 20;
        break;

      case 4:
        // Bottom left
        bottom = true;
        left = true;
        leftNum = 20;
        break;
    }

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        visible = false;
      });
    });

    return Visibility(
      visible: visible,
      child: IgnorePointer(
        ignoring: true,
        child: SizedBox(
          child: Stack(
            children: [
              SizedBox(
                height: 550,
                child: Stack(
                  children: [
                    Positioned(
                      top: top ? topNum : null,
                      right: right ? rightNum : null,
                      left: left ? leftNum : null,
                      bottom: bottom ? 80 : null,
                      child: Material(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 150),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              message,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  removeOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }
}
