import 'package:brick_hold_em/widgets/input_field.dart';
import 'package:brick_hold_em/widgets/step_title.dart';
import 'package:flutter/material.dart';
import 'package:brick_hold_em/models/new_user.dart';

/// Step 2: Choose a username with modern styling
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
  State<UsernameStep> createState() =>
      _UsernameStepState();
}

class _UsernameStepState
    extends State<UsernameStep> {
  late final TextEditingController _ctrl;

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
    if (v == null || v.isEmpty) return "Please enter a username";
    final rx = RegExp(r'^[a-zA-Z0-9_.-]+$');
    return rx.hasMatch(v)
        ? null
        : 'Only letters, numbers, and characters . _ -';
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
    );
  }
}