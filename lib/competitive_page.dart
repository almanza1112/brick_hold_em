import 'dart:convert';

import 'package:brick_hold_em/game/game.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:video_player/video_player.dart';
import 'globals.dart' as globals;
import 'package:flutter/services.dart';

class CompetitivePage extends ConsumerStatefulWidget {
  const CompetitivePage({super.key});

  @override
  CompetitivePageState createState() => CompetitivePageState();
}

class CompetitivePageState extends ConsumerState<CompetitivePage> {
  final TextStyle sectionTitleStyle = const TextStyle(
    fontSize: 16,
    color: Colors.white70,
    fontWeight: FontWeight.w600,
  );
  final TextStyle valueStyle = const TextStyle(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  late VideoPlayerController _controller;
  final storage = const FlutterSecureStorage();
  late Future<String?> chipsFuture;

  List<Map<String, dynamic>> _tables = [];
  bool _loadingTables = true;
  int _selectedAnte = 2;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/door_closing.mp4');
    chipsFuture = _getChips();
    _loadTables();
  }

  Future<void> _loadTables() async {
    final snap = await FirebaseFirestore.instance
        .collection('tables_metadata')
        .where('ante', isEqualTo: _selectedAnte)
        .get();

    _tables = snap.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'ante': data['ante'] as int,
        'player_count': data['player_count'] as int,
      };
    }).toList();

    setState(() => _loadingTables = false);
  }

  Future<String?> _getChips() async => storage.read(key: globals.FSS_CHIPS);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _controller.dispose();
                Navigator.pop(context);
              },
            ),
            title: const Text('COMPETITIVE'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterSheet,
              ),
            ],
          ),
          body: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20),
                    child: Text('Ante: $_selectedAnte', style: sectionTitleStyle),
                  ),
                  Expanded(child: _buildTableGrid()),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Hero(
            tag: 'videoPlayer',
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildTableGrid() {
    if (_loadingTables) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_tables.isEmpty) {
      return const Center(
        child: Text('No tables available for this ante', style: TextStyle(color: Colors.white)),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: _tables.length,
      itemBuilder: (context, index) {
        final table = _tables[index];
        return GestureDetector(
          onTap: () => _showJoinSheet(table),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white54),
            ),
            child: Center(
              child: Text(
                '${table['player_count']}/6 players',
                style: valueStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        final options = [2, 5, 10, 25, 50, 100, 250, 500];
        return ListView(
          shrinkWrap: true,
          children: options.map((ante) {
            return ListTile(
              title: Text('Ante: $ante'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedAnte = ante;
                  _loadingTables = true;
                });
                _loadTables();
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showJoinSheet(Map<String, dynamic> table) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.blue,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        double sliderChips = table['ante'].toDouble();
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setState) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Players: ${table['player_count']}/6', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  FutureBuilder<String?>(
                    future: chipsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const CircularProgressIndicator();
                      final maxChips = double.tryParse(snapshot.data!) ?? 0;
                      return Column(
                        children: [
                          Slider(
                            value: sliderChips.clamp(table['ante'].toDouble(), maxChips).toDouble(),
                            min: table['ante'].toDouble(),
                            max: maxChips,
                            divisions: (maxChips - table['ante']).toInt(),
                            label: sliderChips.round().toString(),
                            onChanged: (val) => setState(() => sliderChips = val),
                          ),
                          Text('Chips: ${sliderChips.round()} / ${maxChips.round()}', style: valueStyle),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addUserToTable(table['id'], sliderChips.round());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('START', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addUserToTable(String tableId, int chips) async {
    final username = await storage.read(key: globals.FSS_USERNAME);
    final callable = FirebaseFunctions.instance.httpsCallable('joinTable');
    try {
      final result = await callable.call(
        <String, dynamic>{
          'tableId': tableId,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'name': FirebaseAuth.instance.currentUser!.displayName,
          'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
          'username': username,
          'chips': chips.toString(),
        },
      );
      final data = result.data as Map<String, dynamic>;
      final position = data['position'] as int;
      ref.read(playerPositionProvider.notifier).state = position;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, a1, a2) => GamePage(controller: _controller),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } catch (e) {
      _controller.pause();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString() ?? 'Failed to join table.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))
          ],
        ),
      );
    }
  }
}