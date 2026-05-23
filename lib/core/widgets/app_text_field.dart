import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.controller,
    this.readOnly = false,
  });

  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool readOnly;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: Icon(widget.icon, color: AppColors.textTertiary, size: 22),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 52, minHeight: 24),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _obscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textTertiary,
                ),
                onPressed: () => setState(() => _obscured = !_obscured),
              )
            : null,
      ),
    );
  }
}
