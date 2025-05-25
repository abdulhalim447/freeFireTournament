import 'package:flutter/material.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final bool enabled;
  final Function(bool?) onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'I agree to the ',
              children: [
                TextSpan(
                  text: 'Terms and Conditions',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
