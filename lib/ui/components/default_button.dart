import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {

  final String label;
  final ButtonStyle? buttonStyle;
  final VoidCallback onSubmit;

  const DefaultButton({Key? key, required this.label, required this.onSubmit, this.buttonStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onSubmit,
      style: buttonStyle ?? FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(label),
      ),
    );
  }
}
