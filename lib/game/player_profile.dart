import 'package:flutter/material.dart';

class PlayerProfilePage extends StatefulWidget {

  PlayerProfilePageState createState() => PlayerProfilePageState();
}

class PlayerProfilePageState extends State<PlayerProfilePage> with TickerProviderStateMixin {

late AnimationController _profileAnimationController;
  late Animation<Offset> _profileSlideAnimation;
  @override
  void initState() {
    _profileAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _profileSlideAnimation = Tween<Offset>(
      begin: Offset(0, 2), // Slide in from the bottom
      end: Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.ease,
    ));
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [SlideTransition(
          position: _profileSlideAnimation,
          child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                    
                    Text("HEllO", style: TextStyle(color: Colors.white),)
                ],
              )),
        ),]
      ),
    );
    ;
  }
}