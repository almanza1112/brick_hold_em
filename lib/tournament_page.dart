import 'package:flutter/material.dart';

class TournamentPage extends StatefulWidget {
  const TournamentPage({super.key});

  @override
  State<TournamentPage> createState() => _TournamentPageState();
}

class _TournamentPageState extends State<TournamentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('TOURNAMENT'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            
          ],
        )
        ),
    );
  }
}