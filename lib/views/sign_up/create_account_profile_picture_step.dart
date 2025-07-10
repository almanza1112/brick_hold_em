// lib/views/sign_up/create_account_profile_picture_step.dart

import 'dart:io';
import 'package:brick_hold_em/widgets/step_title.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/models/new_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

/// Step 4: Upload or remove a profile picture with modern styling
class ProfilePictureStep extends StatefulWidget {
  final NewUser user;
  final void Function(String photoPath) onChanged;

  const ProfilePictureStep({
    super.key,
    required this.user,
    required this.onChanged,
  });

  @override
  State<ProfilePictureStep> createState() =>
      _ProfilePictureStepState();
}

class _ProfilePictureStepState
    extends State<ProfilePictureStep> {
  File? _file;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndCrop() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    final cropped = await ImageCropper().cropImage(
      sourcePath: xfile.path,
      uiSettings: [
        AndroidUiSettings(
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.teal,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    if (cropped != null) {
      setState(() => _file = File(cropped.path));
      widget.onChanged(cropped.path);
    }
  }

  void _remove() {
    setState(() => _file = null);
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final avatarProvider = _file != null
        ? FileImage(_file!)
        : (widget.user.photoURL != null && widget.user.photoURL!.isNotEmpty
            ? NetworkImage(widget.user.photoURL!)
            : const AssetImage('assets/images/poker_player.jpeg')
                as ImageProvider);

    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const StepTitle('Profile Picture'),
            const SizedBox(height: 16),

            // Avatar preview
            ClipOval(
              child: Image(
                image: avatarProvider,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Upload button
            TextButton(
              onPressed: _pickAndCrop,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                
              ),
              child: const Text('UPLOAD IMAGE', style: TextStyle(color: Colors.green)),
            ),

            // Remove button
            if (_file != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: _remove,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: const Text('Remove Image'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
