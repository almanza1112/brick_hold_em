// lib/views/sign_up/sign_up_wizard_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brick_hold_em/models/new_user.dart';
import 'information_step.dart';
import 'username_step.dart';
import 'password_step.dart';
import 'create_account_profile_picture_step.dart';
import 'package:brick_hold_em/globals.dart' as globals;
import 'package:brick_hold_em/home_page.dart';

class SignUpWizardPage extends ConsumerStatefulWidget {
  const SignUpWizardPage({super.key});
  @override
  SignUpWizardPageState createState() => SignUpWizardPageState();
}

class SignUpWizardPageState extends ConsumerState<SignUpWizardPage> {
  final _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 4;

  NewUser _newUser = const NewUser();
  final _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());

  void _goTo(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(_formKeys[_currentStep].currentState?.validate() ?? false)) return;
    if (_currentStep == _totalSteps - 1) {
      _submit();
    } else {
      _goTo(_currentStep + 1);
    }
  }

  void _back() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_currentStep > 0) _goTo(_currentStep - 1);
  }

  Future<void> _submit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      if (_newUser.loginType == globals.LOGIN_TYPE_EMAIL) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _newUser.email!,
          password: _newUser.password!,
        );
      }
      final user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': _newUser.fullName,
        'username': _newUser.username,
        'chips': 1000,
      });

      if (_newUser.photoURL != null && _newUser.photoURL!.isNotEmpty) {
        final file = File(_newUser.photoURL!);
        final ref =
            FirebaseStorage.instance.ref('images/$uid/profile_picture.png');
        final upload = await ref.putFile(file);
        final downloadURL = await upload.ref.getDownloadURL();
        await user.updatePhotoURL(downloadURL);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'photoURL': downloadURL});
      }

      await user.updateDisplayName(_newUser.fullName);

      final storage = const FlutterSecureStorage();
      await storage.write(key: globals.FSS_USERNAME, value: _newUser.username);
      await storage.write(key: globals.FSS_CHIPS, value: '1000');

      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(globals.SETTINGS_BACKGROUND_SOUND, true);
      prefs.setBool(globals.SETTINGS_FX_SOUND, true);
      prefs.setBool(globals.SETTINGS_VIBRATE, true);
      prefs.setBool(globals.SETTINGS_GAME_LIVE_CHAT, true);

      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'))
          ],
        ),
      );
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (i) {
        final active = i == _currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: active ? 16 : 12,
          height: 12,
          decoration: BoxDecoration(
            color: active ? Colors.green : Colors.green.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.grey.shade100,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildStepIndicator(),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  InformationStep(
                    formKey: _formKeys[0],
                    user: _newUser,
                    onChanged: (u) => _newUser = u,
                  ),
                  UsernameStep(
                    formKey: _formKeys[1],
                    user: _newUser,
                    onChanged: (username) =>
                        _newUser = _newUser.copyWith(username: username),
                  ),
                  PasswordStep(
                    formKey: _formKeys[2],
                    user: _newUser,
                    onChanged: (pwd) =>
                        _newUser = _newUser.copyWith(password: pwd),
                  ),
                  ProfilePictureStep(
                    user: _newUser,
                    onChanged: (photoURL) =>
                        _newUser = _newUser.copyWith(photoURL: photoURL),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: _back,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 24),
                      ),
                      child: const Text('BACK', style: TextStyle(color: Colors.white)),
                    )
                  else
                    const SizedBox(width: 80),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                    ),
                    child: Text(
                      _currentStep < _totalSteps - 1 ? 'NEXT' : 'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
