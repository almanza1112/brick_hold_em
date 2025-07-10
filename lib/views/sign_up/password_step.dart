import 'package:brick_hold_em/widgets/input_field.dart';
import 'package:brick_hold_em/widgets/step_title.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/models/new_user.dart';

/// Step 3: Set and confirm your password with modern styling
class PasswordStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final NewUser user;
  final void Function(String password) onChanged;

  const PasswordStep({
    super.key,
    required this.formKey,
    required this.user,
    required this.onChanged,
  });

  @override
  State<PasswordStep> createState() =>
      _PasswordStepState();
}

class _PasswordStepState
    extends State<PasswordStep> {
  late final TextEditingController _pwdCtrl;
  late final TextEditingController _confCtrl;
  bool _obsPwd = true;
  bool _obsConf = true;

  @override
  void initState() {
    super.initState();
    _pwdCtrl = TextEditingController(text: widget.user.password ?? '');
    _confCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    _confCtrl.dispose();
    super.dispose();
  }

  String? _validatePwd(String? v) {
    if (v == null || v.isEmpty) return 'Please enter a password';
    final rx = RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d.!@#\$%^&*()\-_+=]{6,}$');
    return rx.hasMatch(v)
        ? null
        : 'Minimum 6 characters, include letters & numbers';
  }

  String? _validateConf(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    return v.trim() == _pwdCtrl.text.trim()
        ? null
        : "Passwords don't match";
  }

  void _updatePassword(String v) {
    widget.onChanged(v.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: widget.formKey,
          child: ListView(
            children: [
              const StepTitle('Set Your Password'),

              // Password field with visibility toggle inside
              InputField(
                controller: _pwdCtrl,
                label: 'Password',
                validator: _validatePwd,
                onChanged: _updatePassword,
                obscureText: _obsPwd,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obsPwd ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obsPwd = !_obsPwd),
                ),
              ),

              // Confirm Password field with visibility toggle inside
              InputField(
                controller: _confCtrl,
                label: 'Confirm Password',
                validator: _validateConf,
                obscureText: _obsConf,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obsConf ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obsConf = !_obsConf),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}