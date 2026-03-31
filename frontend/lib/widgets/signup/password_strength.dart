import 'package:flutter/material.dart';

class PasswordStrengthField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordStrengthField(this.controller, {super.key});

  @override
  State<PasswordStrengthField> createState() => _PasswordStrengthFieldState();
}

class _PasswordStrengthFieldState extends State<PasswordStrengthField> {
  double strength = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: true,
          onChanged: (value) {
            setState(() {
              if (value.length < 6) {
                strength = 0.25;
              } else if (value.length < 8)
                strength = 0.5;
              else if (RegExp(r'[A-Z]').hasMatch(value) &&
                  RegExp(r'[0-9]').hasMatch(value))
                strength = 1;
              else
                strength = 0.75;
            });
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: strength,
          backgroundColor: Colors.white24,
          color: strength < 0.5
              ? Colors.red
              : strength < 0.75
                  ? Colors.orange
                  : Colors.green,
        ),
      ],
    );
  }
}
