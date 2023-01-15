import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final SeparatorDirection direction;
  const Separator({Key? key, required this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == SeparatorDirection.horizontal) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Divider(
          thickness: 2,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
            indent: 10, endIndent: 10),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: VerticalDivider(
          thickness: 2,
          color: Theme.of(context).primaryColor.withOpacity(0.2),
            indent: 10, endIndent: 10),
      );
    }
  }
}

enum SeparatorDirection {
  horizontal, vertical
}
