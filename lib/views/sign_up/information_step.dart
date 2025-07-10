import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/widgets/input_field.dart';
import 'package:brick_hold_em/widgets/step_title.dart';
import 'package:brick_hold_em/models/new_user.dart';

/// Step 1: Collects full name & email; local validation + remote check via Cloud Function.
class InformationStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final NewUser user;
  final void Function(NewUser updated) onChanged;

  const InformationStep({
    super.key,
    required this.formKey,
    required this.user,
    required this.onChanged,
  });

  @override
  InformationStepState createState() => InformationStepState();
}

class InformationStepState extends State<InformationStep> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

  bool _isLoading = false;
  String? _emailErrorText;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName ?? '');
    _emailCtrl = TextEditingController(text: widget.user.email ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _onChanged() {
    widget.onChanged(widget.user.copyWith(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      loginType: 'email',
    ));
    if (_emailErrorText != null) {
      setState(() => _emailErrorText = null);
    }
  }

  String? _validateName(String? v) =>
      (v == null || v.isEmpty) ? 'Please enter your full name' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Please enter your email';
    final rx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return rx.hasMatch(v) ? null : 'Enter a valid email';
  }

  /// Called by the wizard’s Next button.
  /// Runs local validation and then a Cloud Function check.
  Future<bool> validateAndSubmit() async {
    // Clear previous email error
    setState(() => _emailErrorText = null);

    // 1) Local form validation
    if (widget.formKey.currentState?.validate() != true) {
      return false;
    }

    // 2) Show loading spinner
    setState(() => _isLoading = true);

    try {
      // 3) Remote email‐exists check
      final result = await FirebaseFunctions.instanceFor(region: 'us-central1')
          .httpsCallable('verifyEmail')
          .call({'email': _emailCtrl.text.trim()});
      final exists = result.data['exists'] as bool;

      if (exists) {
        // Email already in use
        setState(() {
          _isLoading = false;
          _emailErrorText = 'An account with this email already exists';
        });
        return false;
      }

      // OK
      setState(() => _isLoading = false);
      return true;
    } on FirebaseFunctionsException catch (e) {
      setState(() => _isLoading = false);
      if (e.code == 'invalid-argument') {
        // Show directly under the field
        setState(() => _emailErrorText = e.message);
      } else {
        // Other error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Unknown error')),
        );
      }
      return false;
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
      return false;
    }
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
                const StepTitle('Personal Information'),
                InputField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  validator: _validateName,
                  onChanged: (_) => _onChanged(),
                  textCapitalization: TextCapitalization.words,
                  prefixIcon: const Icon(Icons.person),
                ),
                InputField(
                  controller: _emailCtrl,
                  label: 'Email Address',
                  validator: _validateEmail,
                  errorText: _emailErrorText,
                  onChanged: (_) => _onChanged(),
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
              ],
            ),
          ),
        ),

         if (_isLoading) LinearProgressIndicator(),
      ],
    );
  }
}
