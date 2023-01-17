import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'game/game_main.dart';

class CompetitivePage extends StatefulWidget {
  _CompetitivePageState createState() => _CompetitivePageState();
}

class _CompetitivePageState extends State<CompetitivePage> {
  EdgeInsets titlePadding = const EdgeInsets.only(top: 30, bottom: 0, left: 10);

  bool friendlySwitch = false;
  bool privateSwitch = false;
  double currentSliderValue = 200;
  TextStyle textStyle = const TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300);
  TextStyle titleStyle = const TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('NO LIMIT'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: titlePadding,
              child: Text(
                "MODE",
                style: titleStyle,
              ),
            ),
            SwitchListTile(
                title: Text("Friendly", style: textStyle),
                value: friendlySwitch,
                activeColor: Colors.green.shade500,
                onChanged: (bool value) {
                  setState(() {
                    friendlySwitch = value;
                  });
                }),
            SwitchListTile(
                title: Text("Private", style: textStyle),
                value: privateSwitch,
                activeColor: Colors.green.shade500,
                onChanged: (bool value) {
                  setState(() {
                    privateSwitch = value;
                  });
                }),
            Padding(
              padding: titlePadding,
              child: Text(
                "CHIPS",
                style: titleStyle,
              ),
            ),
            Slider(
                thumbColor: Colors.white,
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                label: currentSliderValue.round().toString(),
                value: currentSliderValue,
                max: 1000,
                onChanged: (double value) {
                  setState(() {
                    currentSliderValue = value;
                  });
                }),
            Center(
              child: Text(
                currentSliderValue.round().toString(),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: titlePadding,
              child: Text(
                "TABLE",
                style: titleStyle,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 150,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(onPageChanged: (index, reason) {
                      print(index);
                    },
                    enlargeCenterPage: true,
                    enlargeFactor: 1),
                    itemCount: 5,
                    itemBuilder:
                        (BuildContext context, int itemIndex, int pageViewIndex) {
                          int itemIndexAdjusted = itemIndex +1;
                          int tableValue = itemIndexAdjusted * 100;
                      return Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(color: Colors.white,border: Border.all(color: Colors.white)),
                        child: Center(child: Text(tableValue.toString(), style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.w700),)),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GameMain()));
                  },
                  child: Text("START", style: TextStyle(color: Colors.white)),
                )
              ],
            ))
          ],
        ),
      )),
    );
  }
}
