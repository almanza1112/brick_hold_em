import 'package:brick_hold_em/friends_page.dart';
import 'package:flutter/material.dart';

class FriendlyPage extends StatefulWidget {
  _FriendlyPageState createState() => _FriendlyPageState();
}

class _FriendlyPageState extends State<FriendlyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('FRIENDLY'),
        backgroundColor: Colors.teal,
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