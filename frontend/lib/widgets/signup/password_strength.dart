import 'package:flutter/material.dart';

class PasswordStrengthField extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? confirmController;
  final String? Function()? onConfirmValidate;

  const PasswordStrengthField(
    this.controller, {
    super.key,
    this.confirmController,
    this.onConfirmValidate,
  });

  @override
  State<PasswordStrengthField> createState() => _PasswordStrengthFieldState();
}

class _PasswordStrengthFieldState extends State<PasswordStrengthField> {
  double strength = 0;
  String? _confirmError;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  void _updateStrength(String value) {
    setState(() {
      if (value.isEmpty) {
        strength = 0;
      } else if (value.length < 6) {
        strength = 0.25;
      } else if (value.length < 8) {
        strength = 0.5;
      } else if (RegExp(r'[A-Z]').hasMatch(value) &&
          RegExp(r'[0-9]').hasMatch(value) &&
          RegExp(r'[!@#\$%^&*]').hasMatch(value)) {
        strength = 1;
      } else if (RegExp(r'[A-Z]').hasMatch(value) &&
          RegExp(r'[0-9]').hasMatch(value)) {
        strength = 0.75;
      } else {
        strength = 0.5;
      }
    });
  }

  String get _strengthLabel {
    if (strength <= 0) return '';
    if (strength <= 0.25) return 'Weak';
    if (strength <= 0.5) return 'Fair';
    if (strength <= 0.75) return 'Good';
    return 'Strong';
  }

  void _validateConfirmPassword() {
    if (widget.confirmController == null) return;
    final confirm = widget.confirmController!.text;
    final password = widget.controller.text;
    setState(() {
      if (confirm.isEmpty) {
        _confirmError = null; // Don't show error if field is empty
      } else if (confirm != password) {
        _confirmError = 'Passwords do not match';
      } else {
        _confirmError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Password field ──
        TextFormField(
          controller: widget.controller,
          obscureText: _obscurePassword,
          onChanged: (value) {
            _updateStrength(value);
            // Re-validate confirm field live if user edits password
            if (widget.confirmController != null &&
                widget.confirmController!.text.isNotEmpty) {
              _validateConfirmPassword();
            }
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Password",
            labelStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // ── Strength indicator ──
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: strength,
                backgroundColor: Colors.white24,
                color: strength < 0.5
                    ? Colors.red
                    : strength < 0.75
                        ? Colors.orange
                        : Colors.green,
              ),
            ),
            if (_strengthLabel.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                _strengthLabel,
                style: TextStyle(
                  color: strength < 0.5
                      ? Colors.red
                      : strength < 0.75
                          ? Colors.orange
                          : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),

        // ── Re-enter Password field (only if confirmController provided) ──
        if (widget.confirmController != null) ...[
          const SizedBox(height: 18),
          Focus(
            // Validate on blur (when user leaves the field)
            onFocusChange: (hasFocus) {
              if (!hasFocus) _validateConfirmPassword();
            },
            child: TextFormField(
              controller: widget.confirmController,
              obscureText: _obscureConfirm,
              onChanged: (_) {
                // Also validate live while typing for better UX
                if (_confirmError != null) _validateConfirmPassword();
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Re-enter Password",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon:
                    const Icon(Icons.lock_outline, color: Colors.white),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                // Inline error shown below the field
                errorText: _confirmError,
                errorStyle: const TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
