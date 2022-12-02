import 'package:brick_hold_em/game/game_table.dart';
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
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
            onPressed: () {
              controller.forward();
            },
            color: Colors.white,
            icon: const Icon(Icons.menu)),
        SlideTransition(
          position: offsetAnimation,
          child: Container(
            width: 250,
            color: Colors.amber,
            child: SafeArea(
                child: Material(
                  color: Colors.amber,
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
                    
                  ],
                ),
                ),
            ),
          ),
        )
      ],
    );
  }
}
