import 'package:brick_hold_em/providers/game_providers.dart';
import 'package:brick_hold_em/game/players/player.dart';
import 'package:brick_hold_em/game/players/player_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GamePlayers extends ConsumerStatefulWidget {
  const GamePlayers({
    Key? key,
  }) : super(key: key);

  @override
  GamePlayersState createState() => GamePlayersState();
}

class GamePlayersState extends ConsumerState with TickerProviderStateMixin {
  double imageRadius = 30;

  DatabaseReference playersRef =
      FirebaseDatabase.instance.ref('tables/1/players');

  TextStyle turnPlayerTextStyle = const TextStyle(
      color: Colors.orange, fontSize: 24, fontWeight: FontWeight.bold);

  var uid = FirebaseAuth.instance.currentUser!.uid;
  bool isPlayersTurn = false;
  final double bottom = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }

  // TODO : make this in to its own class
 Widget player(Player player, int position) {
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

  bool playerDetailsVisible = player.username.isNotEmpty || player.photoURL.isNotEmpty;

  return GestureDetector(
    onTap: () {
      if (playerDetailsVisible) {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            builder: (_) => PlayerProfilePage(player: player));
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min, // Add this line
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
            if (isFolded)
              CircleAvatar(
                backgroundColor: const Color.fromRGBO(255, 255, 255, 0.5),
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
                        if (!isFolded)
                          Image.asset(
                            'assets/images/backside.png',
                            height: 35,
                            width: 25,
                          ),
                        if (!isFolded)
                          Align(
                              alignment: Alignment.center,
                              child: streamedCardCount(player))
                      ],
                    )),
              ),
            if (!isFolded)
              Positioned(
                top: 0,
                left: left ? 0 : null,
                right: right ? 0 : null,
                child: Transform(
                  transform: left
                      ? Matrix4.translationValues(-8, 0, 0)
                      : Matrix4.translationValues(8, 0, 0),
                  child: streamedBlind(player),
                ),
              )
          ],
        ),
        SizedBox(
          height: 35, // Keep your desired height
          width: 100,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Add this line
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (playerDetailsVisible)
                  Text(
                    player.username,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isFolded ? Colors.grey[400] : Colors.amber),
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


  Widget streamedBlind(Player player) {
    return StreamBuilder(
        stream: FirebaseDatabase.instance.ref('tables/1/blinds').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> data =
                snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            if (data['smallBlind'] == player.position) {
              return const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 10,
                  child: Text(
                    "S",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ));
            } else if (data['bigBlind'] == player.position) {
              return const CircleAvatar(
                backgroundColor: Colors.red,
                radius: 10,
                child: Text(
                  "B",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              );
            } else {
              // You are the one of the blinds
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (data['smallBlind'] == ref.read(playerPositionProvider)) {
                  ref.read(userBlindProvider.notifier).state = "small";
                } else if (data['bigBlind'] ==
                    ref.read(playerPositionProvider)) {
                  ref.read(userBlindProvider.notifier).state = "big";
                } else {
                  ref.read(userBlindProvider.notifier).state = "none";
                }
              });

              return const SizedBox();
            }
          } else if (snapshot.hasError) {
            return const Text("Error");
          } else {
            return const CircularProgressIndicator();
          }
        });
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
        stream: FirebaseDatabase.instance
            .ref('tables/1/chips/${player.uid}/chipCount')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // TODO: show error
            return const SizedBox.shrink();
          }

          if (snapshot.hasData) {
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
        });
  }
}
