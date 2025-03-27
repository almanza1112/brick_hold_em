import 'package:brick_hold_em/game/players/server_progress_indicator_turn.dart';
import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/game/players/player.dart';
import 'package:brick_hold_em/game/players/player_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamePlayers extends ConsumerStatefulWidget {
  const GamePlayers({super.key});

  @override
  GamePlayersState createState() => GamePlayersState();
}

class GamePlayersState extends ConsumerState<GamePlayers>
    with TickerProviderStateMixin {
  double imageRadius = 30;
  final DatabaseReference playersRef =
      FirebaseDatabase.instance.ref('tables/1/players');
  final TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold);
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final double bottom = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550,
      child: StreamBuilder(
        stream: playersRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error returning stream of players data"),
            );
          }
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            List<Player> otherPlayersList = [];
            List<int> otherPlayersKeys = [];
            late int playerKey;

            // Loop through each child from the snapshot and assign keys
            for (final child in snapshot.data!.snapshot.children) {
              final childObj = Map<String, dynamic>.from(
                  child.value as Map<dynamic, dynamic>);
              if (childObj['uid'] != uid) {
                final data = Player.fromMap(childObj);
                otherPlayersList.add(data);
                otherPlayersKeys.add(int.parse(child.key.toString()));
              } else {
                playerKey = int.parse(child.key.toString());
              }
            }

            // Adjust the positions so that the current player is centered
            List<int> adjustedOtherPlayersKeys = [];
            for (int i = 0; i < otherPlayersKeys.length; i++) {
              // Subtract by 1 to adjust for available positions (0-4)
              var difference = (otherPlayersKeys[i] - playerKey) - 1;
              if (difference < 0) {
                adjustedOtherPlayersKeys.add(6 + difference);
              } else {
                adjustedOtherPlayersKeys.add(difference);
              }
            }

            // Update StateProviders via Riverpod
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(otherPlayersAdjustedPositionsProvider.notifier).state =
                  adjustedOtherPlayersKeys;
              ref.read(playerPositionProvider.notifier).state = playerKey;
              ref.read(otherPlayersInformationProvider.notifier).state =
                  otherPlayersList;
            });

            // Build a 5-player list (filling missing spots with a dummy "noOne" player)
            List<Player> playersList = <Player>[];
            Player noOne = Player(
                username: "",
                photoURL: "",
                uid: '',
                folded: true,
                position: 20);
            for (int i = 0; i < 5; i++) {
              int matchingIndex = adjustedOtherPlayersKeys.indexOf(i);
              if (matchingIndex != -1) {
                playersList.add(otherPlayersList[matchingIndex]);
              } else {
                playersList.add(noOne);
              }
            }

            return Stack(
              children: [
                // Bottom Right Player
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: playerWidget(playersList[0], 0),
                ),
                // Top Right Player
                Positioned(
                  top: 180,
                  right: 0,
                  child: playerWidget(playersList[1], 1),
                ),
                // Top Middle Player
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: playerWidget(playersList[2], 2),
                ),
                // Top Left Player
                Positioned(
                  top: 180,
                  left: 0,
                  child: playerWidget(playersList[3], 3),
                ),
                // Bottom Left Player
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: playerWidget(playersList[4], 4),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Something went wrong"));
          }
        },
      ),
    );
  }

  /// This widget builds an individual player's avatar along with overlays.
  Widget playerWidget(Player player, int position) {
    bool isFolded = player.folded;
    bool left = false, right = false;
    switch (position) {
      case 0:
        left = true;
        break;
      case 1:
        left = true;
        break;
      case 2:
        left = true;
        break;
      case 3:
        right = true;
        break;
      case 4:
        right = true;
        break;
    }

    bool playerDetailsVisible =
        player.username.isNotEmpty || player.photoURL.isNotEmpty;

    return GestureDetector(
      onTap: () {
        if (playerDetailsVisible) {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              builder: (_) => PlayerProfilePage(player: player));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: <Widget>[
              // *** NEW: Timer Overlay ***
              // Listen to the shared turnOrder stream and show the circular progress
              // indicator if this player's position is the current turn.
              StreamBuilder<DatabaseEvent>(
                stream:
                    FirebaseDatabase.instance.ref('tables/1/turnOrder').onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.snapshot.value == null) {
                    return const SizedBox();
                  }
                  final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map);
                  final int currentTurn = data['turnPlayer'] is int
                      ? data['turnPlayer'] as int
                      : int.parse(data['turnPlayer'].toString());
                  if (player.position == currentTurn) {
                    return ServerProgressIndicatorTurn();
                  }
                  return const SizedBox();
                },
              ),
              // Player avatar
              CircleAvatar(
                backgroundImage: playerDetailsVisible
                    ? NetworkImage(player.photoURL)
                    : const AssetImage('assets/images/poker_player.jpeg')
                        as ImageProvider,
                radius: imageRadius,
              ),
              // Overlay if player is folded
              if (isFolded)
                CircleAvatar(
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 0.5),
                  radius: imageRadius,
                ),
              // Existing overlays (card count, etc.)
              if (playerDetailsVisible)
                Positioned(
                  bottom: bottom,
                  left: left ? 0 : null,
                  right: right ? 0 : null,
                  child: Transform(
                    transform: left
                        ? Matrix4.translationValues(-10, 0, 0)
                        : Matrix4.translationValues(10, 0, 0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (!isFolded)
                          Image.asset(
                            'assets/images/cards/backside.png',
                            height: 35,
                            width: 25,
                          ),
                        if (!isFolded) streamedCardCount(player),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 35,
            width: 100,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (playerDetailsVisible)
                    Text(
                      player.username,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isFolded ? Colors.grey[400] : Colors.amber,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  if (playerDetailsVisible)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.currency_exchange,
                          size: 8,
                          color: isFolded ? Colors.grey[400] : Colors.amber,
                        ),
                        const SizedBox(width: 2),
                        streamedChipCount(player),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget streamedCardCount(Player player) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref('tables/1/cards/playerCards/${player.uid}/cardCount')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox();
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final cardCount = snapshot.data!.snapshot.value;
        if (cardCount == null) {
          return const CircularProgressIndicator();
        }
        return Text(
          "$cardCount",
          style: const TextStyle(
              fontSize: 14,
              color: Colors.amberAccent,
              fontWeight: FontWeight.w700),
        );
      },
    );
  }

  Widget streamedChipCount(Player player) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref('tables/1/chips/${player.uid}/chipCount')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          var data = snapshot.data!.snapshot.value;
          return Text(
            data.toString(),
            style: TextStyle(
                fontSize: 10,
                color: player.folded ? Colors.grey[400] : Colors.amber),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
