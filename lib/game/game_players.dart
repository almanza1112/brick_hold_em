import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/game/player.dart';
import 'package:brick_hold_em/game/player_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'player_profile_page_builder.dart';

class GamePlayers extends ConsumerStatefulWidget {
  const GamePlayers({
    Key? key,
  }) : super(key: key);

  @override
  GamePlayersState createState() => GamePlayersState();
}

class GamePlayersState extends ConsumerState with TickerProviderStateMixin {
  double imageRadius = 30;
  TextStyle chipsText = const TextStyle(fontSize: 10, color: Colors.amber);
  TextStyle playerNameStyle = const TextStyle(
      fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold);

  DatabaseReference playersRef =
      FirebaseDatabase.instance.ref('tables/1/players');

  TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold);

  var uid = FirebaseAuth.instance.currentUser!.uid;
  bool isPlayersTurn = false;
  final double bottom = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 550,
        child: StreamBuilder(
            stream: playersRef.onValue,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error returning stream of players data"),
                );
              }
          
              if (snapshot.hasData) {
                List<Player> otherPlayersList = [];
                List<int> otherPlayersKeys = [];
                late int playerKey;
          
                // Loop through each child from list returned and assign keys
                for (final child in snapshot.data!.snapshot.children) {
                  final childObj = Map<String, dynamic>.from(child.value as Map);
                  if (childObj['uid'] != uid) {
                    final data = Player.fromMap(childObj);
                    otherPlayersList.add(data);
          
                    otherPlayersKeys.add(int.parse(child.key.toString()));
                  } else {
                    playerKey = int.parse(child.key.toString());
                  }
                }
          
                // Make current player the center of the table and reassign
                // rest of the other players keys
                List<int> adjustedOtherPlayersKeys = [];
                for (int i = 0; i < otherPlayersKeys.length; i++) {
                  // You subtract by 1 since you to adjust for there only being positions
                  // 0-4 avaiable in the table
                  var difference = (otherPlayersKeys[i] - playerKey) - 1;
                  if (difference < 0) {
                    adjustedOtherPlayersKeys.add(6 + difference);
                  } else {
                    adjustedOtherPlayersKeys.add(difference);
                  }
                }
          
                // Update the StateProvider
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(otherPlayersAdjustedPositionsProvider.notifier).state =
                      adjustedOtherPlayersKeys;
          
                  ref.read(playerPositionProvider.notifier).state = playerKey;
          
                  ref.read(otherPlayersInformationProvider.notifier).state =
                      otherPlayersList;
                });
          
                List<Player> playersList = <Player>[];
                Player noOne = Player(username: "", photoURL: "", uid: '');
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
                      child: player(playersList[0], 0),
                    ),

                    // Top Right Player
                    Positioned(
                      top: 180,
                      right: 0,
                      child: player(playersList[1], 1),
                    ),
                    
                    // Top Middle Player
                    Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        child: player(playersList[2], 2)),
                    
                    // Top Left Player
                    Positioned(
                        top: 180, left: 0, child: player(playersList[3], 3)),
                    
                    // Bottom Left Player
                    Positioned(
                        left: 0, bottom: 0, child: player(playersList[4], 4)),
                  ],
                );
              } else {
                return const Text("something went wrong");
              }
            })),
      ),
    );
  }

  // TODO : make this in to its own class
  Widget player(Player player, int position) {
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
          Navigator.push(
            context,
            PlayerProfilePageBuilder(
              widget: PlayerProfilePage(
                player: player,
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: playerDetailsVisible
                    ? NetworkImage(player.photoURL)
                    : const AssetImage('assets/images/poker_player.jpeg')
                        as ImageProvider,
                radius: imageRadius,
              ),
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
                          Image.asset(
                            'assets/images/backside.png',
                            height: 35,
                            width: 25,
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: streamedCardCount(player))
                        ],
                      )),
                ),
            ],
          ),
          SizedBox(
            height: 35,
            width: 100,
            child: Column(
              children: [
                const Expanded(child: SizedBox()),
                if (playerDetailsVisible)
                  Text(
                    player.username,
                    style: playerNameStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                if (playerDetailsVisible)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.currency_exchange,
                        size: 8,
                        color: Colors.amber,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      streamedChipCount(player)
                    ],
                  ),
                if (!playerDetailsVisible)
                  const Text(
                    "Waiting..",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget streamedCardCount(Player player) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref('tables/1/cards/playerCards/${player.uid}/cardCount')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // TODO: do something here, show error??
          }

          if (snapshot.hasData) {
            var data = snapshot.data!.snapshot.value;

            return Text(
              "$data",
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.w700),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget streamedChipCount(Player player) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('tables/1/chips/${player.uid}/chipCount').onValue,
        builder: (context, snapshot) {
          
          if (snapshot.hasError) {
            // TODO: show error
          }

          if (snapshot.hasData) {
            var data = snapshot.data!.snapshot.value;

            return Text(
              data.toString(),
              style: chipsText,
            );
          } else {
            return const Text("loading...");
          }
        });
  }
}
