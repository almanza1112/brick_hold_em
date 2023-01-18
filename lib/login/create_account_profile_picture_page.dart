import 'package:flutter/material.dart';

class CreateAccountProfilePicturePage extends StatefulWidget {
  _CreateAccountProfilePictureState createState() =>
      _CreateAccountProfilePictureState();
}

class _CreateAccountProfilePictureState
    extends State<CreateAccountProfilePicturePage> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
    EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
    EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

    TextStyle formFieldLabelStyle = const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

        TextStyle textButtonStyle = const TextStyle(color: Colors.white);
    return Scaffold(
      backgroundColor: Colors.brown.shade300,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade300,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 30, right: 30),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: Text("Profile Picture",
                  style: TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/TESTING.jpg'),
            radius: 120,
          ),
          TextButton(onPressed: () {}, child: Text("UPLOAD IMAGE", style: textButtonStyle,)),
          TextButton(onPressed: (){}, child: Text("CHOOSE FROM OUR GALLERY", style: textButtonStyle,)),
          TextButton(onPressed: (){}, child: Text("LETS PLAY", style: textButtonStyle,))],
      ),
    );
  }
}
