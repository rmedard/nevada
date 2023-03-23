import 'package:flutter/material.dart';
import 'package:nevada/ui/screens/elements/screen_elements.dart';

class Employees extends StatelessWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return ScreenElements().defaultBodyFrame(
        context: context,
        title: 'Personnel',
        actions: FilledButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nouvel employé'),
            onPressed: (){}),
        body: Text('data'));
  }
}
