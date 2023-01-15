import 'package:flutter/material.dart';

class ScreenElements {
  Widget defaultBodyFrame(
      {required BuildContext context,
      required String title,
      required Widget actions,
      required Widget body}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: Theme.of(context).textTheme.headline1),
              actions
            ]),
            const SizedBox(height: 20),
            body
          ],
        ),
      ),
    );
  }
}