import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserChipsWidget extends StatelessWidget {
  final BoxConstraints constraints;
  const UserChipsWidget({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    double chipsImageWidth = 70;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final chipStream =
        FirebaseDatabase.instance.ref('tables/1/chips/$uid/chipCount').onValue;

    return Positioned(
      bottom: 190,
      left: (constraints.maxWidth / 2) - (chipsImageWidth / 2),
      child: SizedBox(
        width: chipsImageWidth,
        height: chipsImageWidth,
        child: StreamBuilder<DatabaseEvent>(
          stream: chipStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final chipCount = snapshot.data!.snapshot.value?.toString() ?? "0";
            return Stack(
              children: [
                Image.asset('assets/images/casino-chips.png',
                    width: chipsImageWidth),
                Center(
                  child: Text(
                    chipCount,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
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