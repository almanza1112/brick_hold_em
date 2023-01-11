
import 'package:flutter/material.dart';

import 'game/game_main.dart';

class CompetitivePage extends StatefulWidget {
  _CompetitivePageState createState() => _CompetitivePageState();
}

class _CompetitivePageState extends State<CompetitivePage> {
  
  bool friendlySwitch = false;
  double currentSliderValue = 200;

  @override
  Widget build(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('COMPETITIVE'),
        backgroundColor: Colors.blue,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Material(
          color: Colors.blue,
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Friendly", style: textStyle,),
                value: friendlySwitch, 
                onChanged: (bool value){
                  setState(() {
                    friendlySwitch = value;
                  });
                }),
              Slider(
                thumbColor: Colors.white,
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                label: currentSliderValue.round().toString(),
                
                value: currentSliderValue, 
                max: 1000,
                onChanged: (double value){
                  setState(() {
                    currentSliderValue = value;
                    print(currentSliderValue.round());
                  });
                }),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameMain()));
                      }, 
                      child: Text("Start"))
                  ],
                ) 
              )
            ],
          ),
        )
        ),
    );
  }
}