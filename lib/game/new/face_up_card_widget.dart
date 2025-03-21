import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaceUpCardWidget extends ConsumerWidget {
  final double tableCardWidth;
  final double tableCardHeight;
  const FaceUpCardWidget(
      {super.key, required this.tableCardWidth, required this.tableCardHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveFaceUpCard = ref.watch(faceUpCardProvider);
    return liveFaceUpCard.when(
      data: (event) {
        var map = event.snapshot.value! as Map<Object?, Object?>;
        var d = map[map.keys.first] as List<Object?>;
        return Image.asset("assets/images/${d[d.length - 1]}.png",
            width: tableCardWidth, height: tableCardHeight);
      },
      error: (error, stack) => Text(error.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
