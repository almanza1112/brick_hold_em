
import 'package:flutter/material.dart';

class CompetitivePage extends StatefulWidget {
  _CompetitivePageState createState() => _CompetitivePageState();
}

class _CompetitivePageState extends State<CompetitivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('COMPETITIVE'),
        backgroundColor: Colors.blue,
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