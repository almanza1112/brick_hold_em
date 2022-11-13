
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]).then((value) => runApp(GameWidget(game: MyGame())));
}

class MyGame extends FlameGame {

  SpriteComponent background = SpriteComponent();
  SpriteComponent twoClubs = SpriteComponent();

  final double cardHeight = 100.0;
  final double cardWidth = 50.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final screenWidth = size[0];
    final screenHeight = size[1];

    add(background
      ..sprite = await loadSprite('background.webp')
      ..size = size);

    twoClubs
      ..sprite = await loadSprite('2_of_clubs.png')
      ..size = Vector2(cardWidth, cardHeight)
      ..y = 100;
    add(twoClubs);
  }
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuthState(),
    );
  }
}
