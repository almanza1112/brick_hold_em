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
              onPressed: () {controller.forward();},
              color: Colors.white,
              icon: const Icon(Icons.menu)),
          SlideTransition(
            position: offsetAnimation,
            child: Container(
              width: 200,
              color: Colors.amber,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: (){
                        controller.reverse();
                      },
                      color: Colors.black,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black))
                      ),
                      child: const Text(
                        "Exit Table",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ),
                  
                  Text("aaaaaaaaaa")
                ],
              ),
            ),
          )
        ],
    );
  }
}
