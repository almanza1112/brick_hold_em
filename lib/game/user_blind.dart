import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserBlind extends ConsumerStatefulWidget {
  const UserBlind({Key? key}) : super(key: key);

  @override
  _UserBlindState createState() => _UserBlindState();
}

class _UserBlindState extends ConsumerState<UserBlind> {
  @override
  Widget build(BuildContext context) {
    //print('it be hitting');
    //print(ref.read(userBlindProvider));
    return Positioned(
      bottom: 190,
      left: 50,
      child: 
      Visibility(
        visible: ref.watch(userBlindProvider) == 'none' ? false : true,
        child: CircleAvatar(
          backgroundColor: ref.watch(userBlindProvider) == 'small' ? Colors.blue : Colors.red,
          child: Text(ref.watch(userBlindProvider) == 'small' ? 'S' : 'B', style: const TextStyle(color: Colors.white),)),
      ));
  }
}
