import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ServerLinearProgressIndicatorTurn extends StatefulWidget {
  const ServerLinearProgressIndicatorTurn({super.key});

  @override
  _ServerLinearProgressIndicatorTurnState createState() =>
      _ServerLinearProgressIndicatorTurnState();
}

class _ServerLinearProgressIndicatorTurnState
    extends State<ServerLinearProgressIndicatorTurn> {
  // Total turn duration (in seconds) must match your server logic.
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
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (expirationTimestamp != null) {
        int nowMs = DateTime.now().millisecondsSinceEpoch;
        int remainingMs = expirationTimestamp! - nowMs;
        if (remainingMs < 0) remainingMs = 0;
        double newProgress = 1.0 - (remainingMs / (turnDuration * 1000));
        newProgress = newProgress.clamp(0.0, 1.0);
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
    // Calculate remaining seconds for display.
    int remainingSeconds = 0;
    if (expirationTimestamp != null) {
      int nowMs = DateTime.now().millisecondsSinceEpoch;
      int remainingMs = expirationTimestamp! - nowMs;
      if (remainingMs < 0) remainingMs = 0;
      remainingSeconds = (remainingMs / 1000).round();
    }
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              minHeight: 60,
              value: progress,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.lerp(Colors.black, Colors.red, progress) ?? Colors.red,
              ),
              backgroundColor: Colors.grey[300],
            ),
            Text(
              "$remainingSeconds",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}