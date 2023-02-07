import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


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

    final ImagePicker imagePicker = ImagePicker();

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
      body: Stack(children: [
        ListView(
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
              backgroundImage: AssetImage('assets/images/poker_player.jpeg'),
              radius: 120,
            ),
            TextButton(
                onPressed: () async {
                  final XFile? pickedImage =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  if(pickedImage != null){
                    cropImage(pickedImage);
                  }
                },
                child: Text(
                  "UPLOAD IMAGE",
                  style: textButtonStyle,
                )),
            // TextButton(
            //     onPressed: () {},
            //     child: Text(
            //       "CHOOSE FROM OUR GALLERY",
            //       style: textButtonStyle,
            //     )),
          ],
        ),
        SafeArea(
            child: Align(
                alignment: Alignment.bottomRight, child: letsPlayButton()))
      ]),
    );
  }

  Widget letsPlayButton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextButton(
          onPressed: () {},
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5)),
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.red)))),
          child: const Text(
            "FINISH",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  void cropImage(XFile pickedImage) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      cropStyle: CropStyle.circle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
          
        ),
      ],
    );

    
  }
}
