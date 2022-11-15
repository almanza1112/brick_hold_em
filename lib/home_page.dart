import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';
import 'settings_page.dart';
import 'game_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  //              FirebaseAuth.instance.currentUser!.displayName!,
  //              FirebaseAuth.instance.currentUser!.email!,


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        color: Colors.brown,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.group)),
                  ) 
                ),
                
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('1000 chips')
                  )
                ),
              
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.local_movies)
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) =>  SettingsPage()));
                          },
                          icon: const Icon(Icons.settings)
                        )
                      ],
                    )
                  )
                ),
              ],
            ),

            MaterialButton(
                    onPressed: () {
                       Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GameWidget(game: GamePage())));
                    },
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                    child: const Text(
                      "Start Playing",
                      style: TextStyle(color: Colors.white, fontSize: 20),),
                  )

          ],
        ),
      ),
    );
  }
}
