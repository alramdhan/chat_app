import 'package:flutter/material.dart';

class FlutterAppTextField extends StatelessWidget {
  const FlutterAppTextField({
    super.key,
    this.keyboardType,
    this.maxLines = 1,
    this.autoCorrect = true,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.enableSuggestions = true,
    this.label,
  });

  final TextInputType? keyboardType;
  final int maxLines;
  final bool autoCorrect;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final bool enableSuggestions;
  final Widget? label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      autocorrect: false,
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      decoration: InputDecoration(
        label: label,
      ),
    );
  }
}