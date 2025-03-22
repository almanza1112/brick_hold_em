import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------
/// Deck Widget
/// ------------------------
/// Displays the deck card image and the number of cards left.
class DeckWidget extends ConsumerWidget {
  const DeckWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    return GestureDetector(
      onTap: () async {
        await ref.read(gameServiceProvider).addCard(uid, ref);
      },
      child: Container(
        width: 40,
        height: 56,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            // Replace with your actual deck image asset.
            Image.asset("assets/images/backside.png", fit: BoxFit.cover),
            Center(
              child: StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref('tables/1/cards/dealer/deckCount')
                    .onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int count = snapshot.data!.snapshot.value as int;
                    return Text(
                      "$count",
                      style: const TextStyle(
                        color: Colors.amberAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}