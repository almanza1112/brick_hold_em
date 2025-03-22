// File: chip_count_notifier.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChipCountNotifier extends StateNotifier<int> {
  ChipCountNotifier() : super(0) {
    _fetchChipCount();
  }

  Future<void> _fetchChipCount() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await FirebaseDatabase.instance.ref('tables/1/chips/$uid/chipCount').get();
    if (snapshot.value != null) {
      state = int.tryParse(snapshot.value.toString()) ?? 0;
    }
  }

  void subtractChips(int amount) {
    state = state - amount;
  }

  void addChips(int amount) {
    state = state + amount;
  }
}

final chipCountProvider =
    StateNotifierProvider<ChipCountNotifier, int>((ref) => ChipCountNotifier());