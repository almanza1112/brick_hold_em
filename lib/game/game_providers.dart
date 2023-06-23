import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final faceUpCardProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference faceUpCardRef =
      FirebaseDatabase.instance.ref('tables/1/cards/faceUpCard');

  return faceUpCardRef.onValue;
});


final turnPlayerProvider = StreamProvider<DatabaseEvent>((ref) {
  DatabaseReference turnOrderRef =
      FirebaseDatabase.instance.ref('tables/1/turnOrder/turnPlayer');

  return turnOrderRef.onValue;
});

