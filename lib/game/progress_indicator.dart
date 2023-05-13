import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorTurn extends StatefulWidget {
  const ProgressIndicatorTurn({super.key});

  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicatorTurn>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> colorTween;
  bool isOtherPlayersTurn = false;
  DatabaseReference turnPlayerRef =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late Timer _timer;
  int _start = 60;


void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          //changeTurnPlayer();
        }
      });

    colorTween =
        controller.drive(ColorTween(begin: Colors.black, end: Colors.red));
    controller.repeat(reverse: false);
    
    turnPlayerRef.onValue.listen((event) {
      String turnPlayerUid = event.snapshot.value as String;


      if (turnPlayerUid == uid) {
        // it is your turn
        //startTimer();
        controller.stop();
        setState(() {
          isOtherPlayersTurn = false;
        });


      } else {
        // Other Players turn
        controller.reset();
        controller.forward();
        setState(() {
          isOtherPlayersTurn = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("siuuuu");
    return Stack(
      children: [
        Positioned(
          bottom: 215,
          right: 20,
          child: SizedBox(
            height: 60,
            width: 60,
            child: Visibility(
              visible: isOtherPlayersTurn,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                value: controller.value,
                valueColor: colorTween,
              ),
            ),
          ),
        ),
      ],
    );
  }

@override
  void dispose() {
    super.dispose();
  }

}
