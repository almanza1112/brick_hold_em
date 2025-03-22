import 'package:brick_hold_em/providers/chip_count_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserChipsWidget extends ConsumerWidget {
  final BoxConstraints constraints;
  const UserChipsWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double chipsImageWidth = 70;
    final chipCount = ref.watch(chipCountProvider);

    return Positioned(
      bottom: 190,
      left: (constraints.maxWidth / 2) - (chipsImageWidth / 2),
      child: SizedBox(
        width: chipsImageWidth,
        height: chipsImageWidth,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/casino-chips.png',
              width: chipsImageWidth,
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
  }
}