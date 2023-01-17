import 'package:brick_hold_em/game/game_chat.dart';
import 'package:brick_hold_em/game/game_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GameSideMenu extends StatefulWidget {
  const GameSideMenu({
    Key? key,
    required this.game,
  }) : super(key: key);

  final GameTable game;

  _GameSideMenuState createState() => _GameSideMenuState();
}

class _GameSideMenuState extends State<GameSideMenu>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offsetAnimation;

  late AnimationController controller2;
  late Animation<Offset> offsetAnimation2;


  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
        controller2 =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
     offsetAnimation2 = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller2, curve: Curves.easeIn));
    
  }

  removePlayer() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference database = FirebaseDatabase.instance.ref('tables/1/players/$uid');
    database.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
          child: IconButton(
              onPressed: () {
                controller.forward();
              },
              color: Colors.white,
              icon: const Icon(Icons.menu)),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
                onPressed: () {
                  controller2.forward();
                },
                color: Colors.white,
                icon: const Icon(Icons.chat_bubble)),
          ),
        ),
        // MENU
        SlideTransition(
          position: offsetAnimation,
          child: mainMenu(),
        ),
        SlideTransition(
          position: offsetAnimation2,
          child: chatSection(),
        )
      ],
    );
  }

  Widget mainMenu() {
    return Container(
            width: 250,
            color: Colors.amber,
            child: SafeArea(
                child: Material(
                  color: Colors.amber,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "MENU",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: IconButton(
                                onPressed: () {
                                  controller.reverse();
                                },
                                color: Colors.black,
                                icon: const Icon(Icons.close),
                              ))
                        ],
                      ),
                      // EXIT TABLE
                      InkWell(
                        splashColor: Colors.black,
                        onTap: () {
                          removePlayer();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children:  const [
                              Expanded(
                                flex: 0, 
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(Icons.exit_to_app),)),
                              Expanded(
                                flex: 1, 
                                child: Text("Exit Table"))
                            ],
                          ),
                        ),
                      ),
                      // INVITE FRIENDS
                      InkWell(
                        splashColor: Colors.black,
                        onTap: () {
                          //Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children: const [
                              Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.group),
                                  )),
                              Expanded(flex: 1, child: Text("Invite Friends"))
                            ],
                          ),
                        ),
                      ),
                      // BUY MORE CHIPS
                      InkWell(
                        splashColor: Colors.black,
                        onTap: () {
                          //Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children: const [
                              Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.money),
                                  )),
                              Expanded(flex: 1, child: Text("Buy Chips"))
                            ],
                          ),
                        ),
                      ),
                    ],
                ),
                  ),
                ),
            ),
          );
  }

  Widget chatSection() {
    return Container(
            width: 300,
            color: Colors.blue,
            child: SafeArea(
              child: Material(
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "CHAT",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              flex: 0,
                              child: IconButton(
                                  onPressed: () {
                                    controller2.reverse();
                                  },
                                  icon: const Icon(Icons.close)))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Messages will appear here")),
                    Expanded(
                      flex: 0,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: "Send message"
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
          );

  }
}
