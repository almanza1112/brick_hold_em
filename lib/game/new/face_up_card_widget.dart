import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brick_hold_em/providers/face_up_card_notifier.dart'; // Contains faceUpCardCacheProvider

class FaceUpCardWidget extends ConsumerWidget {
  final double tableCardWidth;
  final double tableCardHeight;

  const FaceUpCardWidget({
    super.key,
    required this.tableCardWidth,
    required this.tableCardHeight,
  });

  Future<void> _getPreviousMove(BuildContext context) async {
    // Reference to moves in Firebase.
    final movesRef = FirebaseDatabase.instance.ref('tables/1/moves');
    final snapshot = await movesRef.limitToLast(1).get();
    if (snapshot.value != null) {
      final map = snapshot.value as Map<dynamic, dynamic>;
      final key = map.keys.first;
      List<dynamic> move = map[key]['move'];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Last Move"),
          content: SizedBox(
            width: double.maxFinite,
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: move.map<Widget>((imageName) {
                return Image.asset(
                  "assets/images/$imageName.png",
                  height: 56,
                  width: 40,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the cached face-up card value.
    final faceUpCard = ref.watch(faceUpCardCacheProvider);

    if (faceUpCard.isEmpty) {
      return const CircularProgressIndicator();
    }

    return GestureDetector(
      onTap: () {
        _getPreviousMove(context);
      },
      child: Image.asset(
        "assets/images/$faceUpCard.png",
        width: tableCardWidth,
        height: tableCardHeight,
      ),
    );
  }
}
