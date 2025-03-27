import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChipsWidget extends ConsumerWidget {
  final BoxConstraints constraints;
  const UserChipsWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chipCountAsync = ref.watch(chipCountStreamProvider);

    return chipCountAsync.when(
      data: (chipCount) {
        return Positioned(
          bottom: 190,
          left: (constraints.maxWidth / 2) - (70 / 2),
          child: SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/casino-chips.png',
                  width: 70,
                ),
                Center(
                  child: Text(
                    chipCount.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) => const SizedBox(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
