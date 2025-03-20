import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:brick_hold_em/home_page.dart';
import 'package:brick_hold_em/views/login/new_user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountProfilePicturePage extends StatefulWidget {
  final credential;
  final NewUserInfo newUserInfo;
  const CreateAccountProfilePicturePage(
      {super.key, this.credential, required this.newUserInfo});

  @override
  CreateAccountProfilePictureState createState() =>
      CreateAccountProfilePictureState();
}

class CreateAccountProfilePictureState
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
  UploadTask? uploadTask;
  FirebaseFirestore db = FirebaseFirestore.instance;

  String? newUserEmail;
  String? newUserPassword;
  String? newUserFullName;
  String? newUserUsername;
  String? newUserPhotoURL;
  late File cachedImage;

  @override
  void initState() {
    super.initState();
    newUserEmail = widget.newUserInfo.email;
    newUserPassword = widget.newUserInfo.password;
    newUserFullName = widget.newUserInfo.fullName;
    newUserUsername = widget.newUserInfo.username;
    newUserPhotoURL = widget.newUserInfo.photoURL;

    getCachedImage();
  }

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
              child: ClipOval(
                child: croppedFile != null
                    ? Image.file(
                        File(croppedFile!.path),
                        width: 240,
                        height: 240,
                        fit: BoxFit.cover,
                      )
                    : setProfilePhotoFromURL(),
              ),
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
                  onPressed: () {
                    deleteImage();
                  },
                  child: Text(
                    "DELETE",
                    style: textButtonStyle,
                  )),
            )
          ],
        ),
        SafeArea(
            child: Align(
                alignment: Alignment.bottomRight, child: letsPlayButton()))
      ]),
    );
  }

  getCachedImage() async {
    final cache = DefaultCacheManager();
    File file;
    if (newUserPhotoURL == null) {
      file = await getImageFileFromAssets("assets/images/poker_player.jpeg");
    } else {
      file = await cache.getSingleFile(newUserPhotoURL!);
    }
    setState(() {
      cachedImage = file;
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load(path);
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Image setProfilePhotoFromURL() {
    if (newUserPhotoURL == null) {
      return Image.asset(
        "assets/images/poker_player.jpeg",
        width: 240,
        height: 240,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        newUserPhotoURL!,
        width: 240,
        height: 240,
        fit: BoxFit.cover,
      );
    }
  }

  Widget letsPlayButton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: TextButton(
          onPressed: () {
            createUserAuth();
          },
          style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 5)),
              backgroundColor: WidgetStateProperty.all(Colors.red),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
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
      uiSettings: [
        AndroidUiSettings(
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.teal,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        croppedFile = croppedFile;
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

  void uploadUserProfilePic(String uid) async {
    late File imageFile;
    if (croppedFile == null) {
      imageFile = File(cachedImage.path);
    } else {
      imageFile = File(croppedFile!.path);
    }
    final path = 'images/$uid/profile_picture.png';

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(imageFile);

    final snapshot = await uploadTask!.whenComplete(() {});

    final downloadURL = await snapshot.ref.getDownloadURL();

    db
        .collection("users")
        .doc(uid)
        .update({'photoURL': downloadURL}).then((value) {
      // PhotoURL added
      FirebaseAuth.instance.currentUser!
          .updatePhotoURL(downloadURL)
          .then((value) {
        // Proceed to homepagee
        navigateToHome();
      }).catchError((error) {
        print(error);
      });
    });
  }

  void createUserAuth() async {
    try {
      // ignore: unused_local_variable
      late UserCredential credential;
      if (widget.newUserInfo.loginType == globals.LOGIN_TYPE_EMAIL) {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: newUserEmail!,
          password: newUserPassword!,
        );
      } else if (widget.newUserInfo.loginType == globals.LOGIN_TYPE_GOOGLE) {
        credential =
            await FirebaseAuth.instance.signInWithCredential(widget.credential);
      } else {
        // They are already sign in with Facebook and are finishing the sign up proceess
      }

      // TODO: need to implement error...see credential that is not used above.
      // perhaps a .then().error()

      // Check if user is signed in
      if (FirebaseAuth.instance.currentUser!.email!.isNotEmpty) {
        addUserToFirestore();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print("EXCEPTION: ${e.code}");
      }
    } catch (e) {
      print("the error was here: $e");
    }
  }

  void addUserToFirestore() async {
    await populateSecureStorage();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection("users").doc(uid).set({
      'fullName': newUserFullName,
      'username': newUserUsername,
      'chips': 1000,

      //'photoURL': FirebaseAuth.instance.currentUser!.photoURL
    }).then((value) {
      // User has been added
      // Proceeed to upload profile pic
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(newUserFullName)
          .then((value) {
        uploadUserProfilePic(uid);
      }).catchError((error) {
        print("ERROR ON UPDATING NAME: $error");
      });
    }).catchError((error) {});
  }

  populateSecureStorage() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(key: globals.FSS_USERNAME, value: newUserUsername);
    await storage.write(key: globals.FSS_CHIPS, value: "1000");
  }

  void setSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(globals.SETTINGS_BACKGROUND_SOUND, true);
    prefs.setBool(globals.SETTINGS_FX_SOUND, true);
    prefs.setBool(globals.SETTINGS_VIBRATE, true);
    prefs.setBool(globals.SETTINGS_GAME_LIVE_CHAT, true);
  }

  void navigateToHome() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
}
