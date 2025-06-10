import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// ------------------------
/// Table Chips Widget
/// ------------------------
/// Displays the casino chips image with the pot amount.


class TableChipsWidget extends StatelessWidget {
  final BoxConstraints constraints;
  const TableChipsWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final potStream = FirebaseDatabase.instance.ref('tables/1/pot').onValue;
    return Positioned(
      top: 180,
      left: (constraints.maxWidth / 2) - 50,
      child: SizedBox(
        width: 100,
        height: 100,
        child: StreamBuilder<DatabaseEvent>(
          stream: potStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            // Assume the Firebase data is stored as a map and pot amount is under 'pot1'.
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final potAmount = data['pot1']?.toString() ?? "0";
            return Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/casino-chips.png',
                    width: 50,
                  ),
                ),
                Center(
                  child: Text(
                    potAmount,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}