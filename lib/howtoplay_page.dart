import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  _HowToPlayPageState createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends State<HowToPlayPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('HOW TO PLAY'),
        backgroundColor: Colors.red,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}