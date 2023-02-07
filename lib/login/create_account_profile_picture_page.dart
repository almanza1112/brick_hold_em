import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';


class CreateAccountProfilePicturePage extends StatefulWidget {
  _CreateAccountProfilePictureState createState() =>
      _CreateAccountProfilePictureState();
}

class _CreateAccountProfilePictureState
    extends State<CreateAccountProfilePicturePage> {
  EdgeInsets contentPadding = const EdgeInsets.only(left: 10, right: 10);
  EdgeInsets formFieldLabelPadding = const EdgeInsets.only(bottom: 5);
  EdgeInsets formFieldPadding = const EdgeInsets.only(bottom: 20);

  TextStyle formFieldLabelStyle = const TextStyle(
      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);

  TextStyle textButtonStyle = const TextStyle(color: Colors.white);

  final ImagePicker imagePicker = ImagePicker();
  CroppedFile? croppedFile;
  bool isDeleteVisible = false;

  @override
  Widget build(BuildContext context) {
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
            //   Center(
            //     child: CircleAvatar(
            //      backgroundImage: croppedFile != null ? FileImage(File(croppedFile!.path)) :  const AssetImage("assets/images/poker_player.jpeg") as ImageProvider,
            //      radius: 120,
            //  ),
            //   ),
            // Going with the ClipOval approach since for some reason the CircularAvatar does a transition animation where 
            // you see the background color
            Center(
              child: ClipOval(child: croppedFile != null ? Image.file(File(croppedFile!.path), width: 240, height: 240, fit: BoxFit.cover,)
                    : Image.asset("assets/images/poker_player.jpeg", width: 240, height: 240, fit: BoxFit.cover,),),
            ),
            TextButton(
                onPressed: () async {
                  final XFile? pickedImage =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    cropImage(pickedImage);
                  }
                },
                child: Text(
                  "UPLOAD IMAGE",
                  style: textButtonStyle,
                )),
            
            Visibility(
              visible: isDeleteVisible,
              child: TextButton(
                onPressed: (){
                  deleteImage();
                }, 
                child: Text("DELETE", style: textButtonStyle,)),
            )

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
    CroppedFile? _croppedFile = await ImageCropper().cropImage(
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

    if (_croppedFile != null) {
      setState(() {
        croppedFile = _croppedFile;
        isDeleteVisible = true;
      });
    }
  }

  void deleteImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete"),
            content: const Text("Are you sure you want to delete image??"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL")),
              TextButton(
                  onPressed: () {
                    setState(() {
                      croppedFile = null;
                      isDeleteVisible = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("DELETE"))
            ],
          );
        });
  }
}
