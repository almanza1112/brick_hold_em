import 'package:brick_hold_em/widgets/input_field.dart';
import 'package:brick_hold_em/widgets/step_title.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/models/new_user.dart';

/// Step 1: Collects full name & email with a clean, modern design
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
  State<InformationStep> createState() => _InformationStepState();
}

class _InformationStepState extends State<InformationStep> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;

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

  void _updateModel() {
    widget.onChanged(
      widget.user.copyWith(
        fullName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
      ),
    );
  }

  String? _validateName(String? v) =>
      (v == null || v.isEmpty) ? "Please enter your full name" : null;

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return "Please enter your email";
    final rx = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return rx.hasMatch(v) ? null : 'Please enter a valid email address';
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
              const StepTitle('Personal Information'),

              // Full Name field
              InputField(
                controller: _nameCtrl,
                label: 'Full Name',
                validator: _validateName,
                onChanged: (_) => _updateModel(),
              ),

              // Email field
              InputField(
                controller: _emailCtrl,
                label: 'Email Address',
                validator: _validateEmail,
                onChanged: (_) => _updateModel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
