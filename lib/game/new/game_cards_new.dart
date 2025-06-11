import 'package:brick_hold_em/game/new/bottom_controls/turn_action_buttons_widget.dart';
import 'package:brick_hold_em/game/new/animated_chips_widget.dart';
import 'package:brick_hold_em/game/new/bottom_controls/bottom_controls.dart';
import 'package:brick_hold_em/game/new/player_hand_widget.dart';
import 'package:brick_hold_em/game/new/user_chips_widget.dart';
import 'package:brick_hold_em/game/new/table_cards_widget.dart';
import 'package:brick_hold_em/game/new/table_chips_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------
/// Main GameCards Widget
/// ------------------------
/// This widget is now a container that puts together the smaller widgets.
class GameCardsNew extends ConsumerStatefulWidget {
  const GameCardsNew({super.key});

  @override
  _GameCardsNewState createState() => _GameCardsNewState();
}

class _GameCardsNewState extends ConsumerState<GameCardsNew>
    with AutomaticKeepAliveClientMixin {
  // Example state variables for chip animation.
  bool userChipsToTableVisibility = false;
  double userChipsStartingPosYBottom = 190;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Displays the player’s hand.
            const PlayerHandWidget(),
            // Displays table cards, deck, and table chips.
            TableCardsWidget(constraints: constraints),
            // Displays control buttons (play, pass, shuffle, bet).
            const BottomControls(),
            // Displays animated chips when a bet is made.
            AnimatedChipsWidget(
              visible: userChipsToTableVisibility,
              startPosY: userChipsStartingPosYBottom,
              onAnimationEnd: () {
                setState(() {
                  userChipsToTableVisibility = false;
                  userChipsStartingPosYBottom = 190;
                });
              },
            ),
            UserChipsWidget(constraints: constraints),
            TableChipsWidget(constraints: constraints),
          ],
        );
      },
    );
  }
}
