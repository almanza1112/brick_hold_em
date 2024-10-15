import 'package:flutter/material.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  PurchasePageState createState() => PurchasePageState();
}

class PurchasePageState extends State<PurchasePage> {
  final EdgeInsets purchaseButtonsPadding =
      const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16);
  final EdgeInsets purchaseButtonsInnerPadding = const EdgeInsets.all(24);
  final TextStyle purchaseTextStyle =
      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
          title: const Text('PURCHASE CHIPS'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: purchaseButtonsPadding,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: purchaseButtonsInnerPadding),
              child: Row(
                children: [
                  Text(
                    "100 chips",
                    style: purchaseTextStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "\$0.99",
                    style: purchaseTextStyle,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: purchaseButtonsPadding,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: purchaseButtonsInnerPadding),
              child: Row(
                children: [
                  Text(
                    "500 chips",
                    style: purchaseTextStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "\$4.99",
                    style: purchaseTextStyle,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: purchaseButtonsPadding,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: purchaseButtonsInnerPadding),
              child: Row(
                children: [
                  Text(
                    "1000 chips",
                    style: purchaseTextStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "\$9.99",
                    style: purchaseTextStyle,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: purchaseButtonsPadding,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: purchaseButtonsInnerPadding),
              child: Row(
                children: [
                  Text(
                    "5000 chips",
                    style: purchaseTextStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    "\$19.99",
                    style: purchaseTextStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
