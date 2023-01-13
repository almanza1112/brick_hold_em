import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePicturePage extends StatefulWidget {
  _EditProfilePicturePageState createState() => _EditProfilePicturePageState();
}

class _EditProfilePicturePageState extends State<EditProfilePicturePage> {
  double imageSize = 170;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('PROFILE PICTURE'),
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: imageSize,
              height: imageSize,
                child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL!))),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "UPDATE PICTURE",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
