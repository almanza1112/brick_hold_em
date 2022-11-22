import 'package:flutter/material.dart';

class AdsPage extends StatefulWidget {

  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: const Text('Earn Chips'),
        backgroundColor: Colors.amber,
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