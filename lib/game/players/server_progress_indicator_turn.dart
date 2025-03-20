import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ServerProgressIndicatorTurn extends StatefulWidget {
  const ServerProgressIndicatorTurn({super.key});

  @override
  ServerProgressIndicatorTurnState createState() =>
      ServerProgressIndicatorTurnState();
}

class ServerProgressIndicatorTurnState
    extends State<ServerProgressIndicatorTurn> {
  // Total turn duration (seconds) must match your server logic.
  final int turnDuration = 30;
  // Current progress value (0.0 to 1.0)
  double progress = 0.0;
  Timer? _timer;
  int? expirationTimestamp;
  StreamSubscription<DatabaseEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    // Listen to the shared turnExpiration value from Firebase.
    _subscription = FirebaseDatabase.instance
        .ref('tables/1/turnOrder/turnExpiration')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final ts = int.tryParse(event.snapshot.value.toString());
        if (ts != null) {
          // Only update if still mounted.
          if (mounted) {
            setState(() {
              expirationTimestamp = ts;
            });
          }
          _startTimer();
        }
      }
    });
  }

  void _startTimer() {
    // Cancel any previous timer.
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (expirationTimestamp != null) {
        int nowMs = DateTime.now().millisecondsSinceEpoch;
        int remainingMs = expirationTimestamp! - nowMs;
        if (remainingMs < 0) remainingMs = 0;
        double newProgress = 1.0 - (remainingMs / (turnDuration * 1000));
        if (newProgress > 1.0) newProgress = 1.0;
        // Check mounted before calling setState.
        if (!mounted) return;
        setState(() {
          progress = newProgress;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: CircularProgressIndicator(
        strokeWidth: 10,
        value: progress,
        valueColor: AlwaysStoppedAnimation<Color>(
          Color.lerp(Colors.black, Colors.red, progress) ?? Colors.red,
        ),
      ),
    );
  }
}
