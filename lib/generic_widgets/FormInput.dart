import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final brown = const Color.fromARGB(255, 80, 62, 33);
  final orange = const Color.fromARGB(255, 212, 134, 34);
  final TextEditingController textController;
  final String labelText;
  final bool obscureText;
  final String? errorText;
  const FormInput({
    super.key,
    required this.textController,
    required this.labelText,
    required this.obscureText,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: TextField(
        controller: textController,
        obscureText: obscureText,
        style: TextStyle(
          color: brown,
        ),
        cursorColor: orange,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: orange,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: brown,
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(color: brown, fontWeight: FontWeight.w500),
          errorText: errorText,
        ),
      ),
    );
  }
}
