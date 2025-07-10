// lib/views/sign_up/create_account_username_step.dart

import 'package:flutter/material.dart';
import 'package:brick_hold_em/widgets/input_field.dart';
import 'package:brick_hold_em/widgets/step_title.dart';
import 'package:brick_hold_em/models/new_user.dart';

/// Step 2: Choose a username with modern styling and validation
class UsernameStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final NewUser user;
  final void Function(String username) onChanged;

  const UsernameStep({
    super.key,
    required this.formKey,
    required this.user,
    required this.onChanged,
  });

  @override
  UsernameStepState createState() => UsernameStepState();
}

class UsernameStepState extends State<UsernameStep> {
  late final TextEditingController _ctrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.user.username ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String? _validator(String? v) {
    if (v == null || v.isEmpty) return 'Please enter a username';
    final rx = RegExp(r'^[a-zA-Z0-9_.-]+$');
    return rx.hasMatch(v) ? null : 'Only letters, numbers, and . _ - allowed';
  }

  /// Called by wizard's Next: runs local validation and shows errors
  Future<bool> validateAndSubmit() async {
    setState(() => _isLoading = true);
    // trigger rebuild to show spinner
    await Future.delayed(Duration.zero);

    final valid = widget.formKey.currentState?.validate() ?? false;

    setState(() => _isLoading = false);
    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: widget.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                const StepTitle('Choose a Username'),
                InputField(
                  controller: _ctrl,
                  label: 'Username',
                  validator: _validator,
                  onChanged: (v) => widget.onChanged(v.trim()),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
