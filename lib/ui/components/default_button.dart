import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {

  final String label;

  const DefaultButton({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(label),
      ),
    );
  }
}
