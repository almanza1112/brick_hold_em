import 'package:brick_hold_em/friends_page.dart';
import 'package:flutter/material.dart';

class TournamentPage extends StatefulWidget {
  _TournamentPageState createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('TOURNAMENT'),
        backgroundColor: Colors.teal,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              
            ],
          ))
        ),
    );
  }
}