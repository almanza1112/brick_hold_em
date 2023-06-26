import 'package:audioplayers/audioplayers.dart';
import 'package:brick_hold_em/game/game_cards.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:brick_hold_em/game/game_players.dart';
import 'package:http/http.dart' as http;
import 'package:brick_hold_em/globals.dart' as globals;

import 'game_sidemenu.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

extension GlobalPaintBounds on BuildContext {
  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

class GamePageState extends State<GamePage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late String faceUpCardName;
  Matrix4 playersCardsTransform = Matrix4.translationValues(0, 0, 2);

  //List<Widget> tappedCards = <Widget>[];

  double cardWidth = 50;
  double cardHeight = 70;
  //var cardWidgets = <Widget>[];
  //var cardWidgetsBuilderList = <Widget>[];

  bool isYourTurn = false;

  DatabaseReference database = FirebaseDatabase.instance.ref('tables/1');

  final player = AudioPlayer();

  @override
  void initState() {
    addUserToTable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Stack(
        //fit: StackFit.expand,
        children: [
          GameCards(),
          GamePlayers(),
          GameSideMenu(),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  addUserToTable() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    final username = await storage.read(key: globals.FSS_USERNAME);

    var body = {
      'uid' : uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'photoURL': FirebaseAuth.instance.currentUser!.photoURL,
      'username': username,
    };
    http.Response response =
        await http.post(Uri.parse("${globals.END_POINT}/table/join"), body: body);

    //Map data = jsonDecode(response.body);

    print("adduserToTable: ${response.body}");

  }
}
