

import 'package:flutter/material.dart';

class GameChat extends StatefulWidget {
  const GameChat({
    Key? key,
  }) : super(key: key);


  _GameChatState createState() => _GameChatState();
}

class _GameChatState extends State<GameChat> with SingleTickerProviderStateMixin{
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
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: IconButton(
            onPressed: (){
              controller.forward();
            }, 
            color: Colors.white,
            icon: const Icon(Icons.chat_bubble)
          ),
        ),
        SlideTransition(
          position: offsetAnimation,
          child: Container(
            width: 300,
            color: Colors.blue,
            child: SafeArea(
              child: Material(
                color: Colors.blue,
                child: Column(
                  children: <Widget>[
                    Row(
                      children:  [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "CHAT",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),), 
                        ),
                        Expanded(
                          flex: 0,
                          child: IconButton(
                            onPressed: (){
                              controller.reverse();
                            }, 
                            icon: const Icon(Icons.close)
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),)
      ],
    );
  }
}