import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  const HowToPlayPage({super.key});

  @override
  State<HowToPlayPage> createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends State<HowToPlayPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('HOW TO PLAY'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
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