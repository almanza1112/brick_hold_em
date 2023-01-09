import 'package:flutter/material.dart';

class AdsPage extends StatefulWidget {

  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('EARN CHIPS'),
        backgroundColor: Colors.black,
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